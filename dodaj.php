
kristina@kristinaubuntu:~$ cat /var/www/bolnica/dodaj.php
<?php
$conn = new mysqli('localhost', 'bolnica_user', 'Praksa.123', 'bolnica');
$poruka = '';

if ($conn->connect_error) {
    die("Greška pri povezivanju: " . $conn->connect_error);
}
$conn->set_charset("utf8mb4");

$doktor_id   = intval($_GET['doktor_id'] ?? $_POST['doktor_id'] ?? 0);
$pacijent_id = intval($_GET['pacijent_id'] ?? $_POST['pacijent_id'] ?? 0);

if ($doktor_id === 0 || $pacijent_id === 0) {
    header("Location: index.php");
    exit;
}

// Učitaj podatke o doktoru i pacijentu za prikaz u formi
$stmt_d = $conn->prepare("SELECT ime, prezime, specijalizacija FROM doktor WHERE doktor_id = ?");
$stmt_d->bind_param("i", $doktor_id);
$stmt_d->execute();
$doktor = $stmt_d->get_result()->fetch_assoc();

$stmt_p = $conn->prepare("SELECT ime, prezime, jmbg, lbo FROM pacijenti WHERE pacijent_id = ?");
$stmt_p->bind_param("i", $pacijent_id);
$stmt_p->execute();
$pacijent = $stmt_p->get_result()->fetch_assoc();

// Obrada slanja forme
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $lek_id   = intval($_POST['lek_id'] ?? 0);
    $kolicina = intval($_POST['kolicina'] ?? 0);

    if ($lek_id > 0 && $kolicina > 0) {
        $stmt_ins = $conn->prepare("INSERT INTO recept (doktor_id, pacijent_id, lek_id, kolicina) VALUES (?, ?, ?, ?)");
        if ($stmt_ins) {
            $stmt_ins->bind_param("iiii", $doktor_id, $pacijent_id, $lek_id, $kolicina);
            if ($stmt_ins->execute()) {
                // Automatski vraća nazad u karton tog pacijenta
                header("Location: karton.php?pacijent_id=" . $pacijent_id . "&doktor_id=" . $doktor_id);
                exit;
            } else {
                $poruka = "Greška pri upisu: " . $stmt_ins->error;
            }
            $stmt_ins->close();
        } else {
            $poruka = "Greška u pripremi upita: " . $conn->error;
        }
    } else {
        $poruka = "Molimo izaberite lek i unesite ispravnu količinu!";
    }
}

$lekovi = $conn->query("SELECT lek_id, naziv, cena_po_jedinici FROM lek ORDER BY naziv ASC");
?>
<!DOCTYPE html>
<html lang="sr">
<head>
    <meta charset="UTF-8">
    <title>Izdavanje E-Recepta</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 40px; background-color: #f1f5f9; color: #334155; }
        .card { max-width: 540px; margin: auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); }
        h2 { margin-top: 0; color: #0f172a; margin-bottom: 20px; }
        .info-box { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 14px; margin-bottom: 20px; font-size: 14px; line-height: 1.6; }
        .info-box strong { color: #0f172a; }
        .form-group { margin-bottom: 18px; }
        label { display: block; font-weight: 600; margin-bottom: 6px; font-size: 14px; }
        select, input { width: 100%; box-sizing: border-box; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; background: white; }
        .btn-group { display: flex; gap: 10px; margin-top: 25px; }
        .btn { padding: 10px 20px; border-radius: 6px; text-decoration: none; font-weight: 600; font-size: 14px; cursor: pointer; border: none; }
        .btn-primary { background-color: #0284c7; color: white; }
        .btn-secondary { background-color: #e2e8f0; color: #334155; }
        .error { color: #ef4444; margin-bottom: 15px; font-weight: 600; }
    </style>
</head>
<body>
<div class="card">
    <h2>Izdavanje E-Recepta</h2>

    <?php if ($poruka): ?><div class="error"><?= htmlspecialchars($poruka) ?></div><?php endif; ?>

    <!-- Zaključani podaci o doktoru i pacijentu -->
    <div class="info-box">
        <div>Ordinirajući doktor: <strong>Dr <?= htmlspecialchars($doktor['ime'] . ' ' . $doktor['prezime']) ?></strong> (<?= htmlspecialchars($doktor['specijalizacija']) ?>)</div>
        <div>Pacijent: <strong><?= htmlspecialchars($pacijent['ime'] . ' ' . $pacijent['prezime']) ?></strong> (LBO: <?= htmlspecialchars($pacijent['lbo']) ?>)</div>
    </div>

    <form method="POST">
        <!-- Skriveni ID-jevi -->
        <input type="hidden" name="doktor_id" value="<?= $doktor_id ?>">
        <input type="hidden" name="pacijent_id" value="<?= $pacijent_id ?>">

        <div class="form-group">
            <label>Izaberi lek iz kataloga:</label>
            <select name="lek_id" required>
                <option value="">-- Izaberi lek --</option>
                <?php if ($lekovi): ?>
                    <?php while($l = $lekovi->fetch_assoc()): ?>
                        <option value="<?= $l['lek_id'] ?>">
                            <?= htmlspecialchars($l['naziv']) ?> (<?= number_format($l['cena_po_jedinici'], 2) ?> RSD)
                        </option>
                    <?php endwhile; ?>
                <?php endif; ?>
            </select>
        </div>

        <div class="form-group">
            <label>Količina (pakovanja):</label>
            <input type="number" name="kolicina" min="1" max="10" value="1" required>
        </div>

        <div class="btn-group">
            <button type="submit" class="btn btn-primary">Potvrdi i Izdaj Recept</button>
            <a href="karton.php?pacijent_id=<?= $pacijent_id ?>&doktor_id=<?= $doktor_id ?>" class="btn btn-secondary">Odustani</a>
        </div>
    </form>
</div>
</body>
</html>
