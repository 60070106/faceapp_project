<?php

namespace App\Http\Controllers;

use App\Http\Requests\RegisterAuthRequest;
use Auth;
use  JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

use App\User;
use App\Picture;

class PictureController extends Controller
{
    public function compare(Request $request)
    {

        $picture = new Picture;

        $username = $request->username;
        $image = $request->image;

        $picture->username = $username;
        $picture->image = $image;

        date_default_timezone_set("Asia/Bangkok");

        $data = 'data:image/png;base64,'.$image;
        $source = fopen($data, 'r');
        $savedFileCheck = 'image/checkimg/'.$username.'_'.date("Y-m-d").'_'.date("h-i-sa").'.jpeg';
        $destination = fopen($savedFileCheck , 'w');
        stream_copy_to_stream($source, $destination);
        fclose($source);
        fclose($destination);

        if(User::where('username', $username) != null) {
            $querryDB = User::where('username', $username)->first();
            $dataDB = 'data:image/png;base64,'.$querryDB->image;
            $sourceDB = fopen($dataDB, 'r');
            $savedFileDB = 'image/querry_fromDB/'.$username.'_'.date("Y-m-d").'_'.date("h-i-sa").'.jpeg';
            $destinationDB = fopen($savedFileDB , 'w');
            stream_copy_to_stream($sourceDB, $destinationDB);
            fclose($sourceDB);
            fclose($destinationDB);

            $output = exec('py C:\xampp\htdocs\backend_laravel\resources\py\facial_processer.py "'.$savedFileCheck.'" "'.$savedFileDB.'"');
            $str = iconv('TIS-620','UTF-8', $output);

            $picture->percentage = $str;
        }
        else {
            $picture->percentage = "Not found your db picture!";
        }
        

        $picture->save();

        return  response()->json([
            'success' => true,
            'percentage' => $str,
        ]);
    }
}
