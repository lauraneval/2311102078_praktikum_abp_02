<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class ProductFactory extends Factory
{
    public function definition(): array
    {
        $products = [
            'Beras Premium 5kg', 'Minyak Goreng 2L', 'Gula Pasir 1kg',
            'Tepung Terigu 1kg', 'Susu Full Cream', 'Kopi Kapal Api',
            'Teh Botol Sosro', 'Indomie Goreng', 'Sabun Mandi Lifebuoy',
            'Shampo Pantene', 'Pasta Gigi Pepsodent', 'Detergen Rinso 1kg',
            'Kecap Manis ABC', 'Saus Sambal Indofood', 'Garam Dapur',
            'Mie Sedaap', 'Biskuit Roma', 'Susu Kental Manis',
            'Mentega Blue Band', 'Sirup Marjan',
        ];

        return [
            'nama_produk' => $this->faker->unique()->randomElement($products),
            'deskripsi'   => $this->faker->sentence(10),
            'harga'       => $this->faker->numberBetween(2000, 150000),
            'stok'        => $this->faker->numberBetween(5, 200),
        ];
    }
}
