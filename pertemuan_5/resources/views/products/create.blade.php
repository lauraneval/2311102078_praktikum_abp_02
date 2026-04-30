<x-app-layout>
    <x-slot name="header">
        <div class="flex items-center gap-3">
            <a href="{{ route('products.index') }}"
               class="rounded-lg bg-gray-100 p-2 text-gray-600 hover:bg-gray-200 transition">
                ← Kembali
            </a>
            <h2 class="text-xl font-semibold leading-tight text-gray-800">
                ➕ Tambah Produk Baru
            </h2>
        </div>
    </x-slot>

    <div class="py-8">
        <div class="mx-auto max-w-2xl px-4 sm:px-6 lg:px-8">
            <div class="overflow-hidden rounded-2xl bg-white shadow-md">
                <div class="border-b border-gray-100 bg-indigo-600 px-6 py-4">
                    <p class="text-sm font-medium text-indigo-100">Isi form di bawah untuk menambahkan produk baru ke inventaris.</p>
                </div>
                <form action="{{ route('products.store') }}" method="POST" class="space-y-5 p-6">
                    @csrf

                    {{-- Nama Produk --}}
                    <div>
                        <label for="nama_produk" class="block text-sm font-semibold text-gray-700 mb-1">
                            Nama Produk <span class="text-red-500">*</span>
                        </label>
                        <input type="text" id="nama_produk" name="nama_produk"
                               value="{{ old('nama_produk') }}"
                               placeholder="Contoh: Beras Premium 5kg"
                               class="w-full rounded-lg border px-4 py-2.5 text-sm shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500
                                      {{ $errors->has('nama_produk') ? 'border-red-400 bg-red-50' : 'border-gray-300' }}">
                        @error('nama_produk')
                            <p class="mt-1 text-xs text-red-600">{{ $message }}</p>
                        @enderror
                    </div>

                    {{-- Deskripsi --}}
                    <div>
                        <label for="deskripsi" class="block text-sm font-semibold text-gray-700 mb-1">
                            Deskripsi <span class="text-gray-400 font-normal">(opsional)</span>
                        </label>
                        <textarea id="deskripsi" name="deskripsi" rows="3"
                                  placeholder="Tuliskan deskripsi singkat produk..."
                                  class="w-full rounded-lg border px-4 py-2.5 text-sm shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500
                                         {{ $errors->has('deskripsi') ? 'border-red-400 bg-red-50' : 'border-gray-300' }}">{{ old('deskripsi') }}</textarea>
                        @error('deskripsi')
                            <p class="mt-1 text-xs text-red-600">{{ $message }}</p>
                        @enderror
                    </div>

                    {{-- Harga & Stok --}}
                    <div class="grid grid-cols-1 gap-5 sm:grid-cols-2">
                        <div>
                            <label for="harga" class="block text-sm font-semibold text-gray-700 mb-1">
                                Harga (Rp) <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <span class="absolute left-3 top-1/2 -translate-y-1/2 text-sm text-gray-400 font-medium">Rp</span>
                                <input type="number" id="harga" name="harga"
                                       value="{{ old('harga') }}"
                                       placeholder="0"
                                       min="0"
                                       class="w-full rounded-lg border py-2.5 pl-10 pr-4 text-sm shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500
                                              {{ $errors->has('harga') ? 'border-red-400 bg-red-50' : 'border-gray-300' }}">
                            </div>
                            @error('harga')
                                <p class="mt-1 text-xs text-red-600">{{ $message }}</p>
                            @enderror
                        </div>

                        <div>
                            <label for="stok" class="block text-sm font-semibold text-gray-700 mb-1">
                                Stok <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <input type="number" id="stok" name="stok"
                                       value="{{ old('stok') }}"
                                       placeholder="0"
                                       min="0"
                                       class="w-full rounded-lg border py-2.5 pl-4 pr-12 text-sm shadow-sm transition focus:outline-none focus:ring-2 focus:ring-indigo-500
                                              {{ $errors->has('stok') ? 'border-red-400 bg-red-50' : 'border-gray-300' }}">
                                <span class="absolute right-3 top-1/2 -translate-y-1/2 text-sm text-gray-400">pcs</span>
                            </div>
                            @error('stok')
                                <p class="mt-1 text-xs text-red-600">{{ $message }}</p>
                            @enderror
                        </div>
                    </div>

                    {{-- Tombol --}}
                    <div class="flex items-center justify-end gap-3 border-t border-gray-100 pt-5">
                        <a href="{{ route('products.index') }}"
                           class="rounded-lg border border-gray-300 px-5 py-2.5 text-sm font-semibold text-gray-700 hover:bg-gray-100 transition">
                            Batal
                        </a>
                        <button type="submit"
                                class="rounded-lg bg-indigo-600 px-5 py-2.5 text-sm font-semibold text-white shadow hover:bg-indigo-700 transition">
                            💾 Simpan Produk
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</x-app-layout>
