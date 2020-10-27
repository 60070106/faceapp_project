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

        // $data = 'data:image/png;base64,'.$image;
        // $source = fopen($data, 'r');
        // $destination = fopen('image/'.time().'.jpeg' , 'w');

        $output = exec('py C:\xampp\htdocs\RestApi\resources\py\facial_processer.py "'.$name.'" "'.$surname.'"');
        $str = iconv('TIS-620','UTF-8', $output);
        $picture->pytest = $str;

        // stream_copy_to_stream($source, $destination);
        // fclose($source);
        // fclose($destination);


        $picture->save();

        // return $data;
        // return $image;
    }
}
