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
     * The number of dynamic route kinds. Match DYNAMIC_ROUTES.
     */
    private const KINDS = 30;

    /**
     * The number of ids each dynamic route kind renders.
     */
    private const PAGES_PER_KIND = 1000;

    /**
     * Seed the pages the dynamic routes render.
     */
    public function run(): void
    {
        $timestamp = Carbon::now();

        // One upsert per kind keeps the bound parameters under the MySQL
        // limit of 65,535.
        for ($kind = 1; $kind <= self::KINDS; $kind++) {
            $rows = [];

            for ($id = 1; $id <= self::PAGES_PER_KIND; $id++) {
                $rows[] = [
                    'body' => "Benchmark page {$kind}-{$id}",
                    'created_at' => $timestamp,
                    'id' => $id,
                    'kind' => $kind,
                    'title' => "Page {$kind}-{$id}",
                    'updated_at' => $timestamp,
                ];
            }

            Page::query()->upsert($rows, ['kind', 'id'], ['body', 'title', 'updated_at']);
        }
    }
}
