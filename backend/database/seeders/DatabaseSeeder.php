<?php

namespace Database\Seeders;

use App\Models\Page;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Carbon;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the pages the dynamic routes render.
     */
    public function run(): void
    {
        $timestamp = Carbon::now();
        $rows = [];

        for ($id = 1; $id <= 500; $id++) {
            $rows[] = [
                'body' => "Benchmark page {$id}",
                'created_at' => $timestamp,
                'id' => $id,
                'title' => "Page {$id}",
                'updated_at' => $timestamp,
            ];
        }

        Page::query()->upsert($rows, ['id'], ['body', 'title', 'updated_at']);
    }
}
