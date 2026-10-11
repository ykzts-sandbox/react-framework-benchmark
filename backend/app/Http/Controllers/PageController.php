<?php

namespace App\Http\Controllers;

use App\Models\Page;
use Illuminate\Http\JsonResponse;

class PageController extends Controller
{
    public function show(string $id): JsonResponse
    {
        if (preg_match('/\A[1-9]\d*\z/', $id) !== 1) {
            abort(404);
        }

        $page = Page::query()->find($id);

        if ($page === null) {
            abort(404);
        }

        return response()->json([
            'body' => $page->body,
            'id' => $page->id,
            'title' => $page->title,
        ])->header('Cache-Control', 'public, s-maxage=60');
    }
}
