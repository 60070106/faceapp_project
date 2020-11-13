<?php

namespace App;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Tymon\JWTAuth\Contracts\JWTSubject;

class User extends Authenticatable implements JWTSubject
{
    use Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'username', 'realname','surname','phone', 'password',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims()
    {
        return [];
    }

    public static function checkToken($token){
        if($token->token){
            return true;
        }
        return false;
    }

    public static function getCurrentUser($request){
        if(!User::checkToken($request)){
            return response()->json([
             'message' => 'Token is required'
            ],422);
        }
         
        $user = JWTAuth::parseToken()->authenticate();
        return $user;
     }

    // public function routeNotificationForKarix()
    // {
    // return $this->phone;
    // }
}
