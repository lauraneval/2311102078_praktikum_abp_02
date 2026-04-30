<?php

use App\Http\Controllers\ProductController;
use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return redirect()->route('products.index');
});

Route::get('/dashboard', function () {
    return redirect()->route('products.index');
})->middleware(['auth', 'verified'])->name('dashboard');

// Route Profile (dibutuhkan oleh navigation.blade.php bawaan Breeze)
Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

// CRUD Produk
Route::middleware('auth')->group(function () {
    Route::resource('products', ProductController::class);
});

require __DIR__.'/auth.php';
