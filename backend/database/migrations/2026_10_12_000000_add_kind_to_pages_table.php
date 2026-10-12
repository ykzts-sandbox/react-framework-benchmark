<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Each dynamic route kind has its own ids, so the key becomes
     * (kind, id). Rows from before this migration belong to kind 1.
     */
    public function up(): void
    {
        Schema::table('pages', function (Blueprint $table) {
            $table->unsignedSmallInteger('kind')->default(1)->first();
            $table->dropPrimary();
            $table->primary(['kind', 'id']);
        });
    }

    public function down(): void
    {
        Schema::table('pages', function (Blueprint $table) {
            $table->dropPrimary();
            $table->dropColumn('kind');
            $table->primary('id');
        });
    }
};
