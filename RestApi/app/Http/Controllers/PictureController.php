<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

use App\Models\Picture;
use App\Models\Registered_face;

use Validator;

class PictureController extends Controller
{
    public function getpicture(Request $request)
    {

        $name = $request->input('name');
        $surname = $request->input('surname');

        $user = Registered_face::where('name', $name)->where('surname', $surname)->first();

        return $user->img;
    
    }

    public function getdatabasepicture(Request $request)
    {

        $name = $request->input('name');
        $surname = $request->input('surname');

        $user = Picture::where('name', $name)->where('surname', $surname)->first();

        return $user->img;
    
    }


    public function insert(Request $request)
    {
        print_r($request->input());
        $picture = new Picture;
        $name = $request->input('name');
        $surname = $request->input('surname');
        $fileName = $request->input('fileName');
        $image = $request->input('img');

        $picture->name = $name;
        $picture->surname = $surname;
        $picture->fileName = $fileName;
        $picture->img = $image;

        date_default_timezone_set("Asia/Bangkok");

        $data = 'data:image/png;base64,'.$image;
        $source = fopen($data, 'r');
        $savedFileCheck = 'image/checkimg/'.$name.'_'.$surname.'_'.date("Y-m-d").'_'.date("h-i-sa").'.jpeg';
        $destination = fopen($savedFileCheck , 'w');
        stream_copy_to_stream($source, $destination);
        fclose($source);
        fclose($destination);

        if(Registered_face::where('name', $name)->where('surname', $surname)->first() != null) {
            $querryDB = Registered_face::where('name', $name)->where('surname', $surname)->first();
            $dataDB = 'data:image/png;base64,'.$querryDB->img;
            $sourceDB = fopen($dataDB, 'r');
            $savedFileDB = 'image/querry_fromDB/'.$name.'_'.$surname.'_'.date("Y-m-d").'_'.date("h-i-sa").'.jpeg';
            $destinationDB = fopen($savedFileDB , 'w');
            stream_copy_to_stream($sourceDB, $destinationDB);
            fclose($sourceDB);
            fclose($destinationDB);

            $output = exec('py C:\xampp\htdocs\RestApi\resources\py\facial_processer.py "'.$savedFileCheck.'" "'.$savedFileDB.'"');
            $str = iconv('TIS-620','UTF-8', $output);
            $picture->pytest = $str;
        }
        else {
            $picture->pytest = "not found db picture";
        }
        

        $picture->save();

        // return $data;
        // return $image;
    }
}
