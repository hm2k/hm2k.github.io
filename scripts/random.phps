<?php
  error_reporting(E_ALL);
  $imgDir = 'photos/';
  $dir = opendir("$imgDir");
  while (false !== ($file = readdir($dir)))
    {
    $t = @getimagesize($imgDir.'/'.$file);
     if ($file != "." && $file != ".." && $t['2'] < 17 && !is_dir($imgDir.'/'.$file))
        {
            $file_array[] = $file;
          }
    }
  closedir($dir);
  if(!isset($file_array))
    {
    echo 'No image files found';
    }
  else
    {
     shuffle($file_array);
      $randImg = $file_array['0'];
      $size = getimagesize ($imgDir.'/'.$randImg);
      $fp=@fopen($imgDir.'/'.$randImg, "rb");
      if ($size && $fp)
        {
        //header("Content-type: {$size['mime']}");
          fpassthru($fp);
          exit;
        } 
      else 
        {
          echo 'Sorry, No images available in '. $imgDir;
        }
    }
?>
