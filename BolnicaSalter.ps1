Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Data

# ==========================================
# SQL KONEKCIJA
# ==========================================
$connectionString = "Server=.\SQLEXPRESS;Database=bolnica;Integrated Security=True;"

function Execute-QueryList($query) {
    $lista = New-Object System.Collections.ArrayList
    try {
        $conn = New-Object System.Data.SqlClient.SqlConnection($connectionString)
        $conn.Open()
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = $query
        $reader = $cmd.ExecuteReader()
        while ($reader.Read()) {
            [void]$lista.Add($reader.GetValue(0).ToString())
        }
        $reader.Close()
        $conn.Close()
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Greska sa citanjem liste:`n" + $_.Exception.Message, "Greska", "OK", "Error")
    }
    return $lista
}

function Execute-NonQuery($query) {
    try {
        $conn = New-Object System.Data.SqlClient.SqlConnection($connectionString)
        $conn.Open()
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = $query
        [void]$cmd.ExecuteNonQuery()
        $conn.Close()
        return $true
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Greska pri upisu:`n" + $_.Exception.Message, "Greska", "OK", "Error")
        return $false
    }
}

# ==========================================
# GLAVNI PROZOR
# ==========================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "Bolnica - Prijemni salter i zakazivanje pregleda"
$form.Size = New-Object System.Drawing.Size(960, 620)
$form.StartPosition = "CenterScreen"
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = "Fill"
$form.Controls.Add($tabControl)

# TAB 1: ZAKAZIVANJE
$tabZakazi = New-Object System.Windows.Forms.TabPage
$tabZakazi.Text = "Zakazivanje pregleda"
$tabControl.TabPages.Add($tabZakazi)

$lblPac = New-Object System.Windows.Forms.Label; $lblPac.Text = "Izaberite pacijenta:"; $lblPac.Location = New-Object System.Drawing.Point(20, 20); $lblPac.AutoSize = $true
$tabZakazi.Controls.Add($lblPac)

$cbPacijent = New-Object System.Windows.Forms.ComboBox
$cbPacijent.Location = New-Object System.Drawing.Point(20, 45)
$cbPacijent.Size = New-Object System.Drawing.Size(280, 25)
$cbPacijent.DropDownStyle = "DropDownList"
$tabZakazi.Controls.Add($cbPacijent)

$lblDok = New-Object System.Windows.Forms.Label; $lblDok.Text = "Izaberite ordinaciju / doktora:"; $lblDok.Location = New-Object System.Drawing.Point(320, 20); $lblDok.AutoSize = $true
$tabZakazi.Controls.Add($lblDok)

$cbDoktor = New-Object System.Windows.Forms.ComboBox
$cbDoktor.Location = New-Object System.Drawing.Point(320, 45)
$cbDoktor.Size = New-Object System.Drawing.Size(320, 25)
$cbDoktor.DropDownStyle = "DropDownList"
$tabZakazi.Controls.Add($cbDoktor)

$lblDatum = New-Object System.Windows.Forms.Label; $lblDatum.Text = "Datum i vreme:"; $lblDatum.Location = New-Object System.Drawing.Point(660, 20); $lblDatum.AutoSize = $true
$tabZakazi.Controls.Add($lblDatum)

$dtp = New-Object System.Windows.Forms.DateTimePicker
$dtp.Location = New-Object System.Drawing.Point(660, 45)
$dtp.Size = New-Object System.Drawing.Size(150, 25)
$dtp.Format = "Custom"
$dtp.CustomFormat = "yyyy-MM-dd HH:mm"
$tabZakazi.Controls.Add($dtp)

$btnZakazi = New-Object System.Windows.Forms.Button
$btnZakazi.Text = "Zakazi pregled"
$btnZakazi.Location = New-Object System.Drawing.Point(820, 43)
$btnZakazi.Size = New-Object System.Drawing.Size(105, 28)
$btnZakazi.BackColor = [System.Drawing.Color]::FromArgb(26, 115, 232)
$btnZakazi.ForeColor = [System.Drawing.Color]::White
$tabZakazi.Controls.Add($btnZakazi)

$lblTabela = New-Object System.Windows.Forms.Label
$lblTabela.Text = "Pregled zakazanih termina po cekaonicama:"
$lblTabela.Location = New-Object System.Drawing.Point(20, 95)
$lblTabela.AutoSize = $true
$lblTabela.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$tabZakazi.Controls.Add($lblTabela)

# LISTVIEW TABELA
$lv = New-Object System.Windows.Forms.ListView
$lv.Location = New-Object System.Drawing.Point(20, 120)
$lv.Size = New-Object System.Drawing.Size(905, 410)
$lv.View = [System.Windows.Forms.View]::Details
$lv.FullRowSelect = $true
$lv.GridLines = $true

[void]$lv.Columns.Add("ID", 50)
[void]$lv.Columns.Add("Termin", 140)
[void]$lv.Columns.Add("Pacijent", 160)
[void]$lv.Columns.Add("LBO", 110)
[void]$lv.Columns.Add("Doktor", 170)
[void]$lv.Columns.Add("Odeljenje", 130)
[void]$lv.Columns.Add("Status", 100)

$tabZakazi.Controls.Add($lv)

# TAB 2: UNOS NOVOG PACIJENTA
$tabNovi = New-Object System.Windows.Forms.TabPage
$tabNovi.Text = "Prijem novog pacijenta"
$tabControl.TabPages.Add($tabNovi)

$lblIme = New-Object System.Windows.Forms.Label; $lblIme.Text = "Ime:"; $lblIme.Location = New-Object System.Drawing.Point(30, 30); $tabNovi.Controls.Add($lblIme)
$txtIme = New-Object System.Windows.Forms.TextBox; $txtIme.Location = New-Object System.Drawing.Point(160, 27); $txtIme.Size = New-Object System.Drawing.Size(200, 25); $tabNovi.Controls.Add($txtIme)

$lblPrezime = New-Object System.Windows.Forms.Label; $lblPrezime.Text = "Prezime:"; $lblPrezime.Location = New-Object System.Drawing.Point(30, 70); $tabNovi.Controls.Add($lblPrezime)
$txtPrezime = New-Object System.Windows.Forms.TextBox; $txtPrezime.Location = New-Object System.Drawing.Point(160, 67); $txtPrezime.Size = New-Object System.Drawing.Size(200, 25); $tabNovi.Controls.Add($txtPrezime)

$lblJMBG = New-Object System.Windows.Forms.Label; $lblJMBG.Text = "JMBG (13 cifara):"; $lblJMBG.Location = New-Object System.Drawing.Point(30, 110); $tabNovi.Controls.Add($lblJMBG)
$txtJMBG = New-Object System.Windows.Forms.TextBox; $txtJMBG.Location = New-Object System.Drawing.Point(160, 107); $txtJMBG.Size = New-Object System.Drawing.Size(200, 25); $tabNovi.Controls.Add($txtJMBG)

$lblLBO = New-Object System.Windows.Forms.Label; $lblLBO.Text = "LBO (11 cifara):"; $lblLBO.Location = New-Object System.Drawing.Point(30, 150); $lblLBO.AutoSize = $true; $tabNovi.Controls.Add($lblLBO)
$txtLBO = New-Object System.Windows.Forms.TextBox; $txtLBO.Location = New-Object System.Drawing.Point(160, 147); $txtLBO.Size = New-Object System.Drawing.Size(200, 25); $tabNovi.Controls.Add($txtLBO)

$lblDatRodj = New-Object System.Windows.Forms.Label; $lblDatRodj.Text = "Datum rodjenja:"; $lblDatRodj.Location = New-Object System.Drawing.Point(30, 190); $lblDatRodj.Font = New-Object System.Drawing.Font("Segoe UI", 9); $tabNovi.Controls.Add($lblDatRodj)
$dtpRodj = New-Object System.Windows.Forms.DateTimePicker; $dtpRodj.Location = New-Object System.Drawing.Point(160, 187); $dtpRodj.Format = "Short"; $tabNovi.Controls.Add($dtpRodj)

$lblTel = New-Object System.Windows.Forms.Label; $lblTel.Text = "Telefon:"; $lblTel.Location = New-Object System.Drawing.Point(30, 230); $tabNovi.Controls.Add($lblTel)
$txtTel = New-Object System.Windows.Forms.TextBox; $txtTel.Location = New-Object System.Drawing.Point(160, 227); $txtTel.Size = New-Object System.Drawing.Size(200, 25); $tabNovi.Controls.Add($txtTel)

$lblPolisa = New-Object System.Windows.Forms.Label; $lblPolisa.Text = "Broj polise:"; $lblPolisa.Location = New-Object System.Drawing.Point(420, 30); $tabNovi.Controls.Add($lblPolisa)
$txtPolisa = New-Object System.Windows.Forms.TextBox; $txtPolisa.Location = New-Object System.Drawing.Point(550, 27); $txtPolisa.Size = New-Object System.Drawing.Size(200, 25); $tabNovi.Controls.Add($txtPolisa)

# Padajući meni za fond osiguranja
$lblFond = New-Object System.Windows.Forms.Label; $lblFond.Text = "Fond osiguranja:"; $lblFond.Location = New-Object System.Drawing.Point(420, 70); $tabNovi.Controls.Add($lblFond)
$cbFond = New-Object System.Windows.Forms.ComboBox; $cbFond.Location = New-Object System.Drawing.Point(550, 67); $cbFond.Size = New-Object System.Drawing.Size(200, 25); $cbFond.DropDownStyle = "DropDownList"; $tabNovi.Controls.Add($cbFond)
[void]$cbFond.Items.AddRange(@("RFZO", "Uniqa Osiguranje", "Generali Osiguranje", "Wiener Städtische", "DDOR Novi Sad", "Dunav Osiguranje"))
$cbFond.SelectedIndex = 0

$lblPokrice = New-Object System.Windows.Forms.Label; $lblPokrice.Text = "Pokrice (%):"; $lblPokrice.Location = New-Object System.Drawing.Point(420, 110); $tabNovi.Controls.Add($lblPokrice)
$txtPokrice = New-Object System.Windows.Forms.TextBox; $txtPokrice.Location = New-Object System.Drawing.Point(550, 107); $txtPokrice.Size = New-Object System.Drawing.Size(60, 25); $txtPokrice.Text = "100"; $tabNovi.Controls.Add($txtPokrice)

# Logika za procenat osiguranja
$cbFond.Add_SelectedIndexChanged({
    switch ($cbFond.SelectedItem.ToString()) {
        "RFZO"                { $txtPokrice.Text = "100" }
        "Uniqa Osiguranje"    { $txtPokrice.Text = "90" }
        "Generali Osiguranje" { $txtPokrice.Text = "85" }
        "Wiener Städtische"   { $txtPokrice.Text = "80" }
        "DDOR Novi Sad"       { $txtPokrice.Text = "80" }
        "Dunav Osiguranje"    { $txtPokrice.Text = "75" }
        default               { $txtPokrice.Text = "100" }
    }
})

$btnDodajPacijenta = New-Object System.Windows.Forms.Button
$btnDodajPacijenta.Text = "Upisi pacijenta u bazu"
$btnDodajPacijenta.Location = New-Object System.Drawing.Point(160, 280)
$btnDodajPacijenta.Size = New-Object System.Drawing.Size(200, 35)
$btnDodajPacijenta.BackColor = [System.Drawing.Color]::FromArgb(40, 167, 69)
$btnDodajPacijenta.ForeColor = [System.Drawing.Color]::White
$tabNovi.Controls.Add($btnDodajPacijenta)

# ==========================================
# FUNKCIJA ZA UCITAVANJE PODATAKA
# ==========================================
function Ucitaj-Sve() {
    # 1. Popunjavanje tabele
    $lv.Items.Clear()
    try {
        $conn = New-Object System.Data.SqlClient.SqlConnection($connectionString)
        $conn.Open()
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = @"
            SELECT 
                pr.pregled_id,
                CONVERT(varchar, pr.datum_vreme, 120),
                p.ime + ' ' + p.prezime,
                p.lbo,
                'Dr ' + d.ime + ' ' + d.prezime,
                o.naziv_odeljenja,
                pr.status
            FROM pregled pr
            JOIN pacijenti p ON pr.pacijent_id = p.pacijent_id
            JOIN doktor d ON pr.doktor_id = d.doktor_id
            JOIN odeljenje o ON d.odeljenje_id = o.odeljenje_id
            ORDER BY pr.datum_vreme DESC;
"@
        $reader = $cmd.ExecuteReader()
        while ($reader.Read()) {
            $item = New-Object System.Windows.Forms.ListViewItem($reader.GetValue(0).ToString())
            for ($i = 1; $i -lt 7; $i++) {
                [void]$item.SubItems.Add($reader.GetValue($i).ToString())
            }
            [void]$lv.Items.Add($item)
        }
        $reader.Close()
        $conn.Close()
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Greska pri ucitavanju pregleda: " + $_.Exception.Message)
    }

    # 2. Pacijenti lista
    $cbPacijent.Items.Clear()
    $sqlPac = "SELECT '[' + CAST(pacijent_id AS varchar) + '] ' + ime + ' ' + prezime + ' (LBO: ' + lbo + ')' AS Prikaz FROM pacijenti ORDER BY prezime"
    $pacLista = Execute-QueryList $sqlPac
    foreach ($p in $pacLista) {
        [void]$cbPacijent.Items.Add($p)
    }
    if ($cbPacijent.Items.Count -gt 0) { $cbPacijent.SelectedIndex = 0 }

    # 3. Doktori lista
    $cbDoktor.Items.Clear()
    $sqlDok = @"
        SELECT '[' + CAST(d.doktor_id AS varchar) + '] Dr ' + d.ime + ' ' + d.prezime + ' - ' + o.naziv_odeljenja + 
               CASE WHEN o.sef_doktor_id = d.doktor_id THEN ' [SEF]' ELSE '' END AS Prikaz 
        FROM doktor d 
        JOIN odeljenje o ON d.odeljenje_id = o.odeljenje_id
        ORDER BY o.naziv_odeljenja, d.prezime
"@
    $dokLista = Execute-QueryList $sqlDok
    foreach ($d in $dokLista) {
        [void]$cbDoktor.Items.Add($d)
    }
    if ($cbDoktor.Items.Count -gt 0) { $cbDoktor.SelectedIndex = 0 }
}

# Klik: Zakazi pregled
$btnZakazi.Add_Click({
    if ($cbPacijent.SelectedIndex -ge 0 -and $cbDoktor.SelectedIndex -ge 0) {
        $pTekst = $cbPacijent.SelectedItem.ToString()
        $dTekst = $cbDoktor.SelectedItem.ToString()
        
        $pId = [regex]::Match($pTekst, '\[(\d+)\]').Groups[1].Value
        $dId = [regex]::Match($dTekst, '\[(\d+)\]').Groups[1].Value
        $datumVreme = $dtp.Value.ToString("yyyy-MM-dd HH:mm:00")

        $sql = "INSERT INTO pregled (pacijent_id, doktor_id, datum_vreme, status) VALUES ($pId, $dId, '$datumVreme', 'Zakazan')"
        if (Execute-NonQuery $sql) {
            [System.Windows.Forms.MessageBox]::Show("Pregled uspesno zakazan!", "Obavestenje", "OK", "Information")
            Ucitaj-Sve
        }
    }
})

# Klik: Novi pacijent
$btnDodajPacijenta.Add_Click({
    $ime = $txtIme.Text.Trim()
    $prezime = $txtPrezime.Text.Trim()
    $jmbg = $txtJMBG.Text.Trim()
    $lbo = $txtLBO.Text.Trim()
    $tel = $txtTel.Text.Trim()
    $datum = $dtpRodj.Value.ToString("yyyy-MM-dd")

    $polisa = $txtPolisa.Text.Trim()
    $fond = $cbFond.SelectedItem.ToString()
    $pokrice = $txtPokrice.Text.Trim()

    if ($ime -eq "" -or $prezime -eq "" -or $jmbg.Length -ne 13 -or $lbo.Length -ne 11) {
        [System.Windows.Forms.MessageBox]::Show("Unesite ispravno ime, prezime, JMBG (13 cifara) i LBO (11 cifara)!", "Upozorenje", "OK", "Warning")
        return
    }

    $sqlPac = @"
        INSERT INTO pacijenti (ime, prezime, jmbg, lbo, datum_rodjenja, kontakt_telefon) 
        VALUES ('$ime', '$prezime', '$jmbg', '$lbo', '$datum', '$tel');
        
        DECLARE @novi_id INT = SCOPE_IDENTITY();

        INSERT INTO osiguranje (pacijent_id, broj_polise, naziv_fonda, procenat_pokrica)
        VALUES (@novi_id, '$polisa', '$fond', $pokrice);
"@
    if (Execute-NonQuery $sqlPac) {
        [System.Windows.Forms.MessageBox]::Show("Pacijent i polisa uspesno uneti u bazu!", "Obavestenje", "OK", "Information")
        $txtIme.Clear(); $txtPrezime.Clear(); $txtJMBG.Clear(); $txtLBO.Clear(); $txtTel.Clear(); $txtPolisa.Clear()
        $cbFond.SelectedIndex = 0
        $txtPokrice.Text = "100"
        Ucitaj-Sve
        $tabControl.SelectedIndex = 0
    }
})

# Inicijalno ucitavanje
Ucitaj-Sve

# Prikaz prozora
$form.ShowDialog() | Out-Null