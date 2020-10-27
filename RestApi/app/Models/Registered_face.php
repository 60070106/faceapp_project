<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Registered_face extends Model
{
    protected $table = 'register_face';
    protected $primaryKey = 'id';

    public $timestamps = false;
}
