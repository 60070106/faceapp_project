<?php
namespace  App\Http\Controllers;

use App\Http\Requests\RegisterAuthRequest;
use App\User;
use Auth;
use  JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class  AuthController extends  Controller {

    public  function  register(Request  $request) {

        $plainPassword=$request->password;
        $password=bcrypt($request->password);
        $request->request->add(['password' => $password]);
        $created=User::create($request->all());
        $request->request->add(['password' => $plainPassword]);

        return $this->login($request);

    }

    public  function  login(Request  $request) {
        $input = $request->only('username', 'password');
        $jwt_token = null;
        if (!$jwt_token = JWTAuth::attempt($input)) {
            return  response()->json([
                'success' => false,
                'message' => 'username or password invalid.',
            ], 401);
        }

        $username = $request->username;

        DB::table('users')
            ->where('username', $username)
            ->update(['remember_token' => $jwt_token]);

        $user = Auth::user();
         
        return  response()->json([
            'success' => true,
            'token' => $jwt_token,
            'user' => $user
            // 'username' => $username,
            // 'pass' => $password
        ]);
    }


    public  function  logout(Request  $request) {
        if(!User::checkToken($request)){
            return response()->json([
             'message' => 'Token is required',
             'success' => false,
            ],422);
        }
        
        try {
            JWTAuth::invalidate(JWTAuth::parseToken($request->token));
            return response()->json([
                'success' => true,
                'message' => 'User logged out successfully'
            ]);
        } catch (JWTException $exception) {
            return response()->json([
                'success' => false,
                'message' => 'Sorry, the user cannot be logged out'
            ], 500);
        }

        // $this->validate($request, [
        //     'token' => 'required'
        // ]);

        // try {
        //     JWTAuth::invalidate($request->token);
        //     return  response()->json([
        //         'status' => 'ok',
        //         'message' => 'sign out successful.'
        //     ]);
        // } catch (JWTException  $exception) {
        //     return  response()->json([
        //         'status' => 'unknown_error',
        //         'message' => 'sign out not successful.'
        //     ], 500);
        // }
    }

    

    public  function  getAuthUser(Request  $request) {
        $this->validate($request, [
            'token' => 'required'
        ]);

        $user = JWTAuth::authenticate($request->token);
        return  response()->json(['user' => $user]);
    }

    protected function jsonResponse($data, $code = 200)
{
    return response()->json($data, $code,
        ['Content-Type' => 'application/json;charset=UTF-8', 'Charset' => 'utf-8'], JSON_UNESCAPED_UNICODE);
}
}
