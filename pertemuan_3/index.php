<?php
// --------------------------------------------------
// 1. KONEKSI KE DATABASE MYSQL
// --------------------------------------------------
$host     = "localhost";
$user     = "root";
$password = "";
$database = "db_kampus";

$koneksi = mysqli_connect($host, $user, $password, $database);

if (!$koneksi) {
    die("<p style='color:red;font-family:sans-serif;'>
         ❌ Koneksi gagal: " . mysqli_connect_error() . "
         </p>");
}

// --------------------------------------------------
// 2. FUNCTION: HITUNG NILAI AKHIR
//    Menggunakan operator aritmatika dengan bobot:
//    30% Tugas + 30% UTS + 40% UAS
// --------------------------------------------------
function hitungNilaiAkhir($tugas, $uts, $uas) {
    return ($tugas * 0.30) + ($uts * 0.30) + ($uas * 0.40);
}

// --------------------------------------------------
// 3. FUNCTION: TENTUKAN GRADE
//    Menggunakan if/else dan operator perbandingan
// --------------------------------------------------
function tentukanGrade($nilai_akhir) {
    if ($nilai_akhir >= 85) {
        return 'A';
    } elseif ($nilai_akhir >= 75) {
        return 'B';
    } elseif ($nilai_akhir >= 65) {
        return 'C';
    } elseif ($nilai_akhir >= 55) {
        return 'D';
    } else {
        return 'E';
    }
}

// --------------------------------------------------
// 4. AMBIL DATA DARI DATABASE & SIMPAN KE ARRAY ASOSIASI
// --------------------------------------------------
$query  = "SELECT * FROM mahasiswa ORDER BY id ASC";
$result = mysqli_query($koneksi, $query);

// Array asosiatif untuk menampung seluruh data mahasiswa
// yang sudah diolah (nilai akhir, grade, status)
$daftar_mahasiswa = [];

while ($row = mysqli_fetch_assoc($result)) {
    // Panggil function hitungNilaiAkhir() dengan data dari DB
    $nilai_akhir = hitungNilaiAkhir(
        $row['nilai_tugas'],
        $row['nilai_uts'],
        $row['nilai_uas']
    );

    // Tentukan grade menggunakan function tentukanGrade()
    $grade = tentukanGrade($nilai_akhir);

    // Tentukan status lulus menggunakan operator perbandingan
    $status = ($nilai_akhir >= 60) ? 'Lulus' : 'Tidak Lulus';

    // Push data ke array asosiasi dengan key yang deskriptif
    $daftar_mahasiswa[] = [
        'nama'        => $row['nama'],
        'nim'         => $row['nim'],
        'nilai_akhir' => round($nilai_akhir, 2),
        'grade'       => $grade,
        'status'      => $status,
    ];
}

mysqli_close($koneksi);

// --------------------------------------------------
// 5. HITUNG RATA-RATA & NILAI TERTINGGI DARI ARRAY
// --------------------------------------------------
$total_nilai  = 0;
$nilai_tertinggi = 0;
$jumlah       = count($daftar_mahasiswa);

foreach ($daftar_mahasiswa as $mhs) {
    $total_nilai += $mhs['nilai_akhir'];
    if ($mhs['nilai_akhir'] > $nilai_tertinggi) {
        $nilai_tertinggi = $mhs['nilai_akhir'];
    }
}

$rata_rata = ($jumlah > 0) ? round($total_nilai / $jumlah, 2) : 0;

// --------------------------------------------------
// 6. FUNGSI HELPER UNTUK WARNA BADGE
// --------------------------------------------------
function badgeGrade($grade) {
    $colors = [
        'A' => '#16a34a', // hijau tua
        'B' => '#2563eb', // biru
        'C' => '#d97706', // kuning
        'D' => '#ea580c', // oranye
        'E' => '#dc2626', // merah
    ];
    $bg = $colors[$grade] ?? '#6b7280';
    return "<span style='background:{$bg};color:#fff;padding:3px 10px;
                border-radius:12px;font-weight:700;font-size:0.85em;'>
                {$grade}</span>";
}

function badgeStatus($status) {
    if ($status === 'Lulus') {
        return "<span style='background:#dcfce7;color:#15803d;padding:3px 10px;
                    border-radius:12px;font-weight:600;font-size:0.85em;'>
                    ✔ Lulus</span>";
    }
    return "<span style='background:#fee2e2;color:#dc2626;padding:3px 10px;
                border-radius:12px;font-weight:600;font-size:0.85em;'>
                ✘ Tidak Lulus</span>";
}
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistem Nilai Mahasiswa — db_kampus</title>
    <style>
        /* ===== RESET & BASE ===== */
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f4f8;
            color: #1e293b;
            min-height: 100vh;
            padding: 40px 20px;
        }

        /* ===== WRAPPER ===== */
        .container {
            max-width: 960px;
            margin: 0 auto;
        }

        /* ===== HEADER ===== */
        .header {
            background: linear-gradient(135deg, #1e3a5f 0%, #2563eb 100%);
            color: #fff;
            border-radius: 16px;
            padding: 30px 36px;
            margin-bottom: 28px;
            box-shadow: 0 8px 32px rgba(37,99,235,0.18);
        }
        .header h1 {
            font-size: 1.7rem;
            font-weight: 700;
            letter-spacing: -0.5px;
        }
        .header p {
            margin-top: 6px;
            opacity: 0.82;
            font-size: 0.95rem;
        }

        /* ===== TABEL ===== */
        .table-wrap {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.07);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead tr {
            background: #1e3a5f;
            color: #fff;
        }
        thead th {
            padding: 14px 18px;
            text-align: left;
            font-size: 0.88rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        tbody tr {
            border-bottom: 1px solid #e2e8f0;
            transition: background 0.15s;
        }
        tbody tr:hover { background: #f1f5ff; }
        tbody tr:last-child { border-bottom: none; }

        tbody td {
            padding: 13px 18px;
            font-size: 0.95rem;
            vertical-align: middle;
        }

        .nim-cell {
            font-family: 'Courier New', monospace;
            font-size: 0.88rem;
            color: #475569;
        }

        .nilai-cell {
            font-weight: 700;
            font-size: 1rem;
            color: #1e3a5f;
        }

        /* ===== FOOTER STATISTIK ===== */
        .stats-row {
            background: #f8faff;
            border-top: 2px solid #dbeafe;
        }
        .stats-row td {
            padding: 16px 18px;
        }
        .stats-container {
            display: flex;
            gap: 32px;
            align-items: center;
            flex-wrap: wrap;
        }
        .stat-item {
            display: flex;
            flex-direction: column;
        }
        .stat-label {
            font-size: 0.78rem;
            color: #64748b;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 2px;
        }
        .stat-value {
            font-size: 1.3rem;
            font-weight: 800;
            color: #2563eb;
        }

        /* ===== FOOTER PAGE ===== */
        .footer {
            text-align: center;
            margin-top: 24px;
            color: #94a3b8;
            font-size: 0.82rem;
        }
    </style>
</head>
<body>

<div class="container">

    <!-- HEADER -->
    <div class="header">
        <h1>🎓 Sistem Informasi Nilai Mahasiswa</h1>
        <p>Database: <strong>db_kampus</strong> &nbsp;|&nbsp;
           Bobot: Tugas 30% &bull; UTS 30% &bull; UAS 40% &nbsp;|&nbsp;
           Lulus jika Nilai Akhir &ge; 60
        </p>
    </div>

    <!-- TABEL NILAI -->
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Nama Mahasiswa</th>
                    <th>NIM</th>
                    <th>Nilai Akhir</th>
                    <th>Grade</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <?php
                // --------------------------------------------------
                // LOOPING foreach untuk menampilkan isi array asosiasi
                // $daftar_mahasiswa ke dalam baris tabel HTML
                // --------------------------------------------------
                $no = 1;
                foreach ($daftar_mahasiswa as $mhs):
                ?>
                <tr>
                    <td><?= $no++ ?></td>
                    <td><strong><?= htmlspecialchars($mhs['nama']) ?></strong></td>
                    <td class="nim-cell"><?= htmlspecialchars($mhs['nim']) ?></td>
                    <td class="nilai-cell"><?= $mhs['nilai_akhir'] ?></td>
                    <td><?= badgeGrade($mhs['grade']) ?></td>
                    <td><?= badgeStatus($mhs['status']) ?></td>
                </tr>
                <?php endforeach; ?>
            </tbody>

            <!-- BARIS STATISTIK DI BAWAH TABEL -->
            <tfoot>
                <tr class="stats-row">
                    <td colspan="6">
                        <div class="stats-container">
                            <div class="stat-item">
                                <span class="stat-label">📊 Rata-rata Kelas</span>
                                <span class="stat-value"><?= $rata_rata ?></span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-label">🏆 Nilai Tertinggi</span>
                                <span class="stat-value"><?= $nilai_tertinggi ?></span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-label">👥 Jumlah Mahasiswa</span>
                                <span class="stat-value"><?= $jumlah ?></span>
                            </div>
                        </div>
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>

    <div class="footer">
        &copy; <?= date('Y') ?> Naufal Thoriq Muzhaffar &mdash; 2311102078
    </div>

</div>

</body>
</html>