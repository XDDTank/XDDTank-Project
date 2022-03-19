// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.LevelPicCreater

package ddt.view.tips
{
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.DisplayObjectContainer;

    public class LevelPicCreater 
    {

        private static const pathTip:String = "asset.core.leveltip.";
        public static var LEVELTIPCLASSES:Array = ["Level_Tip_0", "Level_Tip_1", "Level_Tip_2", "Level_Tip_3", "Level_Tip_4", "Level_Tip_5", "Level_Tip_6", "Level_Tip_7", "Level_Tip_8", "Level_Tip_9"];


        public static function creatLelvePic(_arg_1:int):Sprite
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:Bitmap;
            var _local_6:Bitmap;
            var _local_2:Sprite = new Sprite();
            if (_arg_1 < 10)
            {
                _local_2.addChild(ComponentFactory.Instance.creatBitmap((pathTip + LEVELTIPCLASSES[_arg_1])));
            }
            else
            {
                if (_arg_1 > 9)
                {
                    _local_3 = int(int((_arg_1 / 10)));
                    _local_4 = (_arg_1 % 10);
                    _local_5 = ComponentFactory.Instance.creatBitmap((pathTip + LEVELTIPCLASSES[_local_3]));
                    _local_6 = ComponentFactory.Instance.creatBitmap((pathTip + LEVELTIPCLASSES[_local_4]));
                    _local_6.x = _local_5.width;
                    _local_2.addChild(_local_5);
                    _local_2.addChild(_local_6);
                };
            };
            return (_local_2);
        }

        public static function creatLevelPicInContainer(_arg_1:DisplayObjectContainer, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:Boolean=true):void
        {
            var _local_6:uint;
            var _local_7:Bitmap;
            var _local_8:Bitmap;
            if (_arg_2 > 9)
            {
                _local_6 = uint(Math.floor((_arg_2 / 10)));
                _local_7 = ComponentFactory.Instance.creat((pathTip + LEVELTIPCLASSES[_local_6]));
                _local_7.x = (_arg_3 - 4);
                _local_7.y = _arg_4;
                _arg_1.addChild(_local_7);
                _local_6 = (_arg_2 % 10);
                _local_8 = ComponentFactory.Instance.creat((pathTip + LEVELTIPCLASSES[_local_6]));
                _local_8.x = ((_local_7.x + _local_7.width) - 3);
                _local_8.y = _local_7.y;
                _arg_1.addChild(_local_8);
            }
            else
            {
                if (_arg_5)
                {
                    _local_6 = 0;
                    _local_7 = ComponentFactory.Instance.creat((pathTip + LEVELTIPCLASSES[_local_6]));
                    _local_7.x = (_arg_3 - 4);
                    _local_7.y = _arg_4;
                    _arg_1.addChild(_local_7);
                    _local_6 = _arg_2;
                    _local_8 = ComponentFactory.Instance.creat((pathTip + LEVELTIPCLASSES[_local_6]));
                    _local_8.x = ((_local_7.x + _local_7.width) - 3);
                    _local_8.y = _local_7.y;
                    _arg_1.addChild(_local_8);
                }
                else
                {
                    _local_6 = _arg_2;
                    _local_8 = ComponentFactory.Instance.creat((pathTip + LEVELTIPCLASSES[_local_6]));
                    _local_8.x = _arg_3;
                    _local_8.y = _arg_4;
                    _arg_1.addChild(_local_8);
                };
            };
        }


    }
}//package ddt.view.tips

