<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});

Route::get('getpicture', 'App\Http\Controllers\PictureController@getpicture');
Route::get('getdatabasepicture', 'App\Http\Controllers\PictureController@getdatabasepicture');
Route::post('postpicture', 'App\Http\Controllers\PictureController@insert');
