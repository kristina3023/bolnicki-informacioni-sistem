
kristina@kristinaubuntu:~$ cat /var/www/bolnica/karton.php
<?php
$conn = new mysqli('localhost', 'bolnica_user', 'Praksa.123', 'bolnica');
if ($conn->connect_error) { die("Greška: " . $conn->connect_error); }
$conn->set_charset("utf8mb4");

$pacijent_id = intval($_GET['pacijent_id'] ?? 0);
$doktor_id   = intval($_GET['doktor_id'] ?? 0);

if ($pacijent_id === 0) {
    header("Location: index.php" . ($doktor_id > 0 ? "?doktor_id=$doktor_id" : ""));
    exit;
}

// Unos nalaza u karton
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['akcija']) && $_POST['akcija'] === 'karton') {
    $dijagnoza = trim($_POST['dijagnoza']);
    $terapija  = trim($_POST['terapija']);
    $napomena  = trim($_POST['napomena']);

    if (!empty($dijagnoza)) {
        $stmt_ins = $conn->prepare("INSERT INTO medicinski_karton (pacijent_id, datum_upisa, dijagnoza, terapija, napomena) VALUES (?, NOW(), ?, ?, ?)");
        $stmt_ins->bind_param("isss", $pacijent_id, $dijagnoza, $terapija, $napomena);
        $stmt_ins->execute();
        header("Location: karton.php?pacijent_id=$pacijent_id&doktor_id=$doktor_id");
        exit;
    }
}

// Podaci o pacijentu i osiguranju
$p_stmt = $conn->prepare("SELECT p.*, os.broj_polise, os.naziv_fonda, os.procenat_pokrica
                          FROM pacijenti p
                          LEFT JOIN osiguranje os ON p.pacijent_id = os.pacijent_id
                          WHERE p.pacijent_id = ?");
$p_stmt->bind_param("i", $pacijent_id);
$p_stmt->execute();
$pacijent = $p_stmt->get_result()->fetch_assoc();

// Istorija lečenja
$karton_stmt = $conn->prepare("SELECT * FROM medicinski_karton WHERE pacijent_id = ? ORDER BY datum_upisa DESC");
$karton_stmt->bind_param("i", $pacijent_id);
$karton_stmt->execute();
$karton_istorija = $karton_stmt->get_result();

// Recepti pacijenta
$recepti_stmt = $conn->prepare("SELECT r.*, l.naziv AS lek_naziv, CONCAT('Dr ', d.ime, ' ', d.prezime) AS doktor_ime
                                FROM recept r
                                JOIN lek l ON r.lek_id = l.lek_id
                                JOIN doktor d ON r.doktor_id = d.doktor_id
                                WHERE r.pacijent_id = ?
                                ORDER BY r.datum_izdavanja DESC");
$recepti_stmt->bind_param("i", $pacijent_id);
$recepti_stmt->execute();
$recepti = $recepti_stmt->get_result();
?>
<!DOCTYPE html>
<html lang="sr">
<head>
    <meta charset="UTF-8">
    <title>Medicinski Karton - <?= htmlspecialchars($pacijent['ime'] ?? '') ?></title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f1f5f9; margin: 0; padding: 25px; color: #1e293b; }
        .container { max-width: 1100px; margin: auto; }
        .btn-back { background: #64748b; color: white; padding: 8px 14px; text-decoration: none; border-radius: 6px; font-weight: bold; }
        .box { background: white; border-radius: 8px; padding: 20px; margin-bottom: 20px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        .info-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; margin-top: 10px; font-size: 14px; }
        .table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .table th { background: #0f172a; color: white; text-align: left; padding: 10px; font-size: 13px; }
        .table td { padding: 10px; border-bottom: 1px solid #cbd5e1; font-size: 13px; }
        textarea, input { width: 100%; box-sizing: border-box; padding: 8px; margin-bottom: 10px; border: 1px solid #cbd5e1; border-radius: 4px; }
        .btn-submit { background: #059669; color: white; border: none; padding: 10px 18px; border-radius: 6px; font-weight: bold; cursor: pointer; }
        .btn-recept { background: #0284c7; color: white; padding: 8px 14px; text-decoration: none; border-radius: 6px; font-weight: bold; }
    </style>
</head>
<body>

<div class="container">
    <div style="margin-bottom: 20px;">
        <a class="btn-back" href="index.php?doktor_id=<?= $doktor_id ?>">&larr; Nazad na raspored</a>
    </div>

    <div class="box">
        <h2 style="margin: 0 0 10px 0; color: #0284c7;"><?= htmlspecialchars(($pacijent['ime'] ?? '') . ' ' . ($pacijent['prezime'] ?? '')) ?></h2>
        <div class="info-grid">
            <div><strong>JMBG:</strong> <?= htmlspecialchars($pacijent['jmbg'] ?? '-') ?></div>
            <div><strong>LBO:</strong> <?= htmlspecialchars($pacijent['lbo'] ?? '-') ?></div>
            <div><strong>Datum rođenja:</strong> <?= htmlspecialchars($pacijent['datum_rodjenja'] ?? '-') ?></div>
            <div><strong>Fond:</strong> <?= htmlspecialchars($pacijent['naziv_fonda'] ?? 'Nema') ?></div>
        </div>
    </div>

    <div class="box">
        <h3>Novi unos u karton</h3>
        <form method="POST">
            <input type="hidden" name="akcija" value="karton">
            <label>Dijagnoza:</label>
            <input type="text" name="dijagnoza" required placeholder="Unesite dijagnozu">
            <label>Terapija:</label>
            <textarea name="terapija" rows="2" placeholder="Preporučena terapija"></textarea>
            <label>Napomena:</label>
            <textarea name="napomena" rows="2" placeholder="Napomena doktora"></textarea>
            <button type="submit" class="btn-submit">Upiši u karton</button>
        </form>
    </div>

    <div class="box">
        <h3>Istorijat lečenja</h3>
        <table class="table">
            <thead>
                <tr>
                    <th>Datum upisa</th>
                    <th>Dijagnoza</th>
                    <th>Terapija</th>
                    <th>Napomena</th>
                </tr>
            </thead>
            <tbody>
                <?php if ($karton_istorija && $karton_istorija->num_rows > 0): ?>
                    <?php while($k = $karton_istorija->fetch_assoc()): ?>
                        <tr>
                            <td><strong><?= htmlspecialchars($k['datum_upisa']) ?></strong></td>
                            <td><?= htmlspecialchars($k['dijagnoza']) ?></td>
                            <td><?= htmlspecialchars($k['terapija']) ?></td>
                            <td><?= htmlspecialchars($k['napomena']) ?></td>
                        </tr>
                    <?php endwhile; ?>
                <?php else: ?>
                    <tr><td colspan="4" style="text-align: center; color: #94a3b8; padding: 15px;">Nema prethodnih upisa u kartonu.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>

    <div class="box">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <h3 style="margin: 0;">Izdati e-recepti</h3>
            <a class="btn-recept" href="dodaj.php?pacijent_id=<?= $pacijent_id ?>&doktor_id=<?= $doktor_id ?>">+ Izdaj novi e-recept</a>
        </div>
        <table class="table">
            <thead>
                <tr>
                    <th>Datum</th>
                    <th>Lek</th>
                    <th>Količina</th>
                    <th>Doktor</th>
                </tr>
            </thead>
            <tbody>
                <?php if ($recepti && $recepti->num_rows > 0): ?>
                    <?php while($r = $recepti->fetch_assoc()): ?>
                        <tr>
                            <td><?= htmlspecialchars($r['datum_izdavanja']) ?></td>
                            <td><strong><?= htmlspecialchars($r['lek_naziv']) ?></strong></td>
                            <td><?= htmlspecialchars($r['kolicina']) ?> kom.</td>
                            <td><?= htmlspecialchars($r['doktor_ime']) ?></td>
                        </tr>
                    <?php endwhile; ?>
                <?php else: ?>
                    <tr><td colspan="4" style="text-align: center; color: #94a3b8; padding: 15px;">Nema izdatih recepata.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
<?php $conn->close(); ?>
