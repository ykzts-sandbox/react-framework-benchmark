<?php

namespace App\Http\Controllers;

use App\Models\Page;
use Illuminate\Http\JsonResponse;

class PageController extends Controller
{
    public function show(string $kind, string $id): JsonResponse
    {
        if (preg_match('/\A[1-9]\d*\z/', $kind) !== 1 || preg_match('/\A[1-9]\d*\z/', $id) !== 1) {
            abort(404);
        }

        $page = Page::query()
            ->where('kind', $kind)
            ->where('id', $id)
            ->first();

        if ($page === null) {
            abort(404);
        }

        return response()->json([
            'body' => $page->body,
            'id' => $page->id,
            'kind' => $page->kind,
            'title' => $page->title,
        ])->header('Cache-Control', 'public, s-maxage=60');
    }
}
