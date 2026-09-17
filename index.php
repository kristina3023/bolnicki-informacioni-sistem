kristina@kristinaubuntu:~$ cat /var/www/bolnica/index.php
<?php
$conn = new mysqli('localhost', 'bolnica_user', 'Praksa.123', 'bolnica');
if ($conn->connect_error) { die("Greška pri povezivanju: " . $conn->connect_error); }
$conn->set_charset("utf8mb4");

$doktori = $conn->query("SELECT d.doktor_id, d.ime, d.prezime, d.specijalizacija, o.naziv_odeljenja
                         FROM doktor d
                         LEFT JOIN odeljenje o ON d.odeljenje_id = o.odeljenje_id
                         ORDER BY d.prezime ASC");

$doktor_id = isset($_GET['doktor_id']) ? intval($_GET['doktor_id']) : 1;

$doktor_info = null;
$pregledi = null;

if ($doktor_id > 0) {
    $stmt = $conn->prepare("SELECT d.ime, d.prezime, d.specijalizacija, o.naziv_odeljenja
                            FROM doktor d
                            LEFT JOIN odeljenje o ON d.odeljenje_id = o.odeljenje_id
                            WHERE d.doktor_id = ?");
    $stmt->bind_param("i", $doktor_id);
    $stmt->execute();
    $doktor_info = $stmt->get_result()->fetch_assoc();

    $stmt_p = $conn->prepare("SELECT pr.pregled_id, pr.datum_vreme, pr.status, p.pacijent_id, p.ime, p.prezime, p.jmbg, p.lbo
                              FROM pregled pr
                              JOIN pacijenti p ON pr.pacijent_id = p.pacijent_id
                              WHERE pr.doktor_id = ?
                              ORDER BY pr.datum_vreme ASC");
    $stmt_p->bind_param("i", $doktor_id);
    $stmt_p->execute();
    $pregledi = $stmt_p->get_result();
}
?>
<!DOCTYPE html>
<html lang="sr">
<head>
    <meta charset="UTF-8">
    <title>Doktorski Portal - Raspored Pregleda</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f1f5f9; margin: 0; padding: 25px; color: #1e293b; }
        .container { max-width: 1100px; margin: auto; background: #fff; padding: 25px; border-radius: 10px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        .top-bar { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #0284c7; padding-bottom: 15px; margin-bottom: 20px; }
        select { padding: 8px 12px; font-size: 14px; border-radius: 6px; border: 1px solid #cbd5e1; }
        .doc-badge { background: #e0f2fe; color: #0369a1; padding: 8px 14px; border-radius: 6px; font-weight: bold; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { background: #0f172a; color: #fff; text-align: left; padding: 12px; font-size: 13px; text-transform: uppercase; }
        td { padding: 12px; border-bottom: 1px solid #cbd5e1; font-size: 14px; }
        tr:hover { background: #f8fafc; }
        .status { padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; display: inline-block; }
        .status-zakazan { background: #fef3c7; color: #92400e; }
        .btn-karton { background: #0284c7; color: white; padding: 6px 12px; text-decoration: none; border-radius: 4px; font-size: 13px; font-weight: bold; }
        .btn-karton:hover { background: #0369a1; }
    </style>
</head>
<body>

<div class="container">
    <div class="top-bar">
        <form method="GET">
            <label><strong>Prijavljeni doktor:</strong> </label>
            <select name="doktor_id" onchange="this.form.submit()">
                <?php while($d = $doktori->fetch_assoc()): ?>
                    <option value="<?= $d['doktor_id'] ?>" <?= ($doktor_id == $d['doktor_id']) ? 'selected' : '' ?>>
                        Dr <?= htmlspecialchars($d['ime'] . ' ' . $d['prezime']) ?> (<?= htmlspecialchars($d['specijalizacija']) ?>)
                    </option>
                <?php endwhile; ?>
            </select>
        </form>
        <?php if ($doktor_info): ?>
            <div class="doc-badge">
                Odeljenje: <?= htmlspecialchars($doktor_info['naziv_odeljenja'] ?? 'Opšte') ?>
            </div>
        <?php endif; ?>
    </div>

    <h3>Dnevni raspored zakazanih pregleda</h3>

    <table>
        <thead>
            <tr>
                <th>Vreme Pregleda</th>
                <th>Pacijent</th>
                <th>JMBG</th>
                <th>LBO</th>
                <th>Status</th>
                <th>Karton</th>
            </tr>
        </thead>
        <tbody>
            <?php if ($pregledi && $pregledi->num_rows > 0): ?>
                <?php while($p = $pregledi->fetch_assoc()): ?>
                    <tr>
                        <td><strong><?= htmlspecialchars($p['datum_vreme']) ?></strong></td>
                        <td><?= htmlspecialchars($p['ime'] . ' ' . $p['prezime']) ?></td>
                        <td><?= htmlspecialchars($p['jmbg']) ?></td>
                        <td><?= htmlspecialchars($p['lbo']) ?></td>
                        <td><span class="status status-zakazan"><?= htmlspecialchars($p['status'] ?? 'Zakazano') ?></span></td>
                        <td>
                            <a class="btn-karton" href="karton.php?pacijent_id=<?= $p['pacijent_id'] ?>&doktor_id=<?= $doktor_id ?>">
                                Otvori karton &rarr;
                            </a>
                        </td>
                    </tr>
                <?php endwhile; ?>
            <?php else: ?>
                <tr><td colspan="6" style="text-align: center; color: #94a3b8; padding: 20px;">Nema zakazanih pregleda za ovog doktora.</td></tr>
            <?php endif; ?>
        </tbody>
    </table>
</div>

</body>
</html>
<?php $conn->close(); ?>
