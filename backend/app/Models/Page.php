<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;

#[Fillable(['body', 'title'])]
class Page extends Model
{
    public $incrementing = false;
}
