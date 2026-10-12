<?php

use App\Http\Controllers\PageController;
use Illuminate\Support\Facades\Route;

Route::get('/pages/{kind}/{id}', [PageController::class, 'show']);
