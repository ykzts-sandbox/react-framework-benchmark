<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;

/**
 * The primary key is (kind, id). Eloquent has no composite keys, so look
 * rows up with where() instead of find().
 */
#[Fillable(['body', 'title'])]
class Page extends Model
{
    public $incrementing = false;
}
