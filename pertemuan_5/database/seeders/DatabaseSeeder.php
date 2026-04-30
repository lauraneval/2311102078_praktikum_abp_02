<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Buat 1 user dummy untuk login
        User::factory()->create([
            'name'     => 'Mas Wowo',
            'email'    => 'wowo@inventaris.com',
            'password' => bcrypt('password'),
        ]);

        $this->call([
            ProductSeeder::class,
        ]);
    }
}
