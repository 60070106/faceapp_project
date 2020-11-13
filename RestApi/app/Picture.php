<?php

namespace App;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Picture extends Model
{
    protected $table = 'facial_picture';
    protected $primaryKey = 'id';
}
