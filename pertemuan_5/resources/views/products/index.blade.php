<x-app-layout>
    <x-slot name="header">
        <div class="flex items-center justify-between">
            <h2 class="text-xl font-semibold leading-tight text-gray-800">
                🏪 Inventaris Toko Pak Cokomi & Mas Wowo
            </h2>
            <a href="{{ route('products.create') }}"
               class="inline-flex items-center gap-2 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-semibold text-white shadow hover:bg-indigo-700 transition">
                + Tambah Produk
            </a>
        </div>
    </x-slot>

    <div class="py-8">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">

            {{-- Alert Notifikasi --}}
            @if (session('success'))
                <div x-data="{ show: true }" x-show="show" x-transition
                     class="mb-6 flex items-center justify-between rounded-lg border border-green-200 bg-green-50 px-4 py-3 text-green-800 shadow-sm">
                    <span class="font-medium">✅ {{ session('success') }}</span>
                    <button @click="show = false" class="ml-4 text-green-500 hover:text-green-700 font-bold text-lg leading-none">&times;</button>
                </div>
            @endif

            {{-- Card Tabel --}}
            <div class="overflow-hidden rounded-2xl bg-white shadow-md">
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-indigo-600">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-bold uppercase tracking-wider text-white">No</th>
                                <th class="px-6 py-3 text-left text-xs font-bold uppercase tracking-wider text-white">Nama Produk</th>
                                <th class="px-6 py-3 text-left text-xs font-bold uppercase tracking-wider text-white">Deskripsi</th>
                                <th class="px-6 py-3 text-left text-xs font-bold uppercase tracking-wider text-white">Harga</th>
                                <th class="px-6 py-3 text-left text-xs font-bold uppercase tracking-wider text-white">Stok</th>
                                <th class="px-6 py-3 text-center text-xs font-bold uppercase tracking-wider text-white">Aksi</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100 bg-white">
                            @forelse ($products as $index => $product)
                                <tr class="hover:bg-indigo-50 transition-colors duration-150">
                                    <td class="px-6 py-4 text-sm text-gray-500">
                                        {{ ($products->currentPage() - 1) * $products->perPage() + $loop->iteration }}
                                    </td>
                                    <td class="px-6 py-4">
                                        <span class="font-semibold text-gray-800">{{ $product->nama_produk }}</span>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-gray-500 max-w-xs truncate">
                                        {{ $product->deskripsi ?? '-' }}
                                    </td>
                                    <td class="px-6 py-4 text-sm font-medium text-gray-700">
                                        Rp {{ number_format($product->harga, 0, ',', '.') }}
                                    </td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold
                                            {{ $product->stok > 20 ? 'bg-green-100 text-green-700' : ($product->stok > 5 ? 'bg-yellow-100 text-yellow-700' : 'bg-red-100 text-red-700') }}">
                                            {{ $product->stok }} pcs
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 text-center" x-data="{ openModal: false }">
                                        <div class="flex items-center justify-center gap-2">
                                            {{-- Tombol Edit --}}
                                            <a href="{{ route('products.edit', $product) }}"
                                               class="inline-flex items-center gap-1 rounded-lg bg-amber-400 px-3 py-1.5 text-xs font-semibold text-white hover:bg-amber-500 transition">
                                                ✏️ Edit
                                            </a>

                                            {{-- Tombol Hapus (trigger modal) --}}
                                            <button @click="openModal = true"
                                                    class="inline-flex items-center gap-1 rounded-lg bg-red-500 px-3 py-1.5 text-xs font-semibold text-white hover:bg-red-600 transition">
                                                🗑️ Hapus
                                            </button>
                                        </div>

                                        {{-- Modal Konfirmasi Hapus (Alpine.js) --}}
                                        <div x-show="openModal"
                                             x-transition:enter="transition ease-out duration-200"
                                             x-transition:enter-start="opacity-0"
                                             x-transition:enter-end="opacity-100"
                                             x-transition:leave="transition ease-in duration-150"
                                             x-transition:leave-start="opacity-100"
                                             x-transition:leave-end="opacity-0"
                                             class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm"
                                             @click.self="openModal = false"
                                             style="display: none;">
                                            <div x-show="openModal"
                                                 x-transition:enter="transition ease-out duration-200"
                                                 x-transition:enter-start="opacity-0 scale-95"
                                                 x-transition:enter-end="opacity-100 scale-100"
                                                 class="w-full max-w-sm rounded-2xl bg-white p-6 shadow-2xl mx-4">
                                                <div class="mb-4 flex items-center justify-center">
                                                    <div class="flex h-16 w-16 items-center justify-center rounded-full bg-red-100">
                                                        <span class="text-3xl">🗑️</span>
                                                    </div>
                                                </div>
                                                <h3 class="text-center text-lg font-bold text-gray-800">Konfirmasi Hapus</h3>
                                                <p class="mt-2 text-center text-sm text-gray-500">
                                                    Yakin ingin menghapus produk
                                                    <span class="font-semibold text-red-600">"{{ $product->nama_produk }}"</span>?
                                                    <br>Tindakan ini tidak bisa dibatalkan.
                                                </p>
                                                <div class="mt-6 flex gap-3">
                                                    <button @click="openModal = false"
                                                            class="flex-1 rounded-lg border border-gray-300 px-4 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-100 transition">
                                                        Batal
                                                    </button>
                                                    <form action="{{ route('products.destroy', $product) }}" method="POST" class="flex-1">
                                                        @csrf
                                                        @method('DELETE')
                                                        <button type="submit"
                                                                class="w-full rounded-lg bg-red-600 px-4 py-2 text-sm font-semibold text-white hover:bg-red-700 transition">
                                                            Ya, Hapus!
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            @empty
                                <tr>
                                    <td colspan="6" class="px-6 py-16 text-center text-gray-400">
                                        <div class="flex flex-col items-center gap-2">
                                            <span class="text-5xl">📦</span>
                                            <p class="text-lg font-medium">Belum ada produk.</p>
                                            <a href="{{ route('products.create') }}" class="text-indigo-500 hover:underline text-sm">Tambah produk pertama</a>
                                        </div>
                                    </td>
                                </tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>

                {{-- Pagination --}}
                @if ($products->hasPages())
                    <div class="border-t border-gray-100 bg-gray-50 px-6 py-4">
                        {{ $products->links() }}
                    </div>
                @endif
            </div>

            {{-- Summary Info --}}
            <p class="mt-4 text-center text-xs text-gray-400">
                Menampilkan {{ $products->firstItem() }}–{{ $products->lastItem() }} dari {{ $products->total() }} produk
            </p>
        </div>
    </div>
</x-app-layout>
