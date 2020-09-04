echo "$#"
if [ "$#" -lt 1 ]
then
  echo "please append video path & model type"
  exit 1
fi
if [ "$#" -eq 1 ]
then
  echo "use default mode type mono+stereo_640x192"
  modeType="mono+stereo_640x192"
else
  modeType=$2
fi


if [ -e "$1" ]
then
  basedir=$(dirname $(readlink -f "$1"))
  filename=${1##*/}
  extension=${filename##*.}
  filename=${filename%%.*}
  echo $filename
  echo $extension
  echo $basedir
else
  echo "movie file not existing"
fi

myImgDir="$basedir/$filename"
echo $myImgDir
if [ ! -d "$myImgDir" ]
then
  mkdir $myImgDir
  ffmpeg -i "$1" -f image2 "$myImgDir/"video-frame%05d.jpg
  echo "===============video converted to frames================="
fi

cd $basedir/../
python test_simple.py --image_path $myImgDir --model_name $modeType

myVideo="$myImgDir-depth.$extension"
ffmpeg -i "$myImgDir/"video-frame%05d_disp.jpeg $myVideo
#ffmpeg  -f image2 -framerate 30 -i "$myImgDir/"video-frame%05d.jpg $myVideo
echo "=================frames converted to video==================="

myStackVideo="$myImgDir-final.$extension"
ffmpeg -i "$basedir/$filename.$extension" -i $myVideo -filter_complex vstack=inputs=2 $myStackVideo
echo "==================videos stacked========================="
