// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.utils.PositionUtils

package ddt.utils
{
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.data.player.BasePlayer;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;

    public class PositionUtils 
    {


        public static function setPos(_arg_1:*, _arg_2:*):*
        {
            var _local_3:Point;
            if ((_arg_2 is String))
            {
                _local_3 = ComponentFactory.Instance.creatCustomObject(_arg_2);
                _arg_1.x = _local_3.x;
                _arg_1.y = _local_3.y;
            }
            else
            {
                if ((_arg_2 is Object))
                {
                    _arg_1.x = _arg_2.x;
                    _arg_1.y = _arg_2.y;
                };
            };
            return (_arg_1);
        }

        public static function creatPoint(_arg_1:String):Point
        {
            return (ComponentFactory.Instance.creatCustomObject(_arg_1));
        }

        public static function adaptNameStyle(_arg_1:BasePlayer, _arg_2:FilterFrameText, _arg_3:GradientText):void
        {
            if (_arg_1)
            {
                if (_arg_1.isOld)
                {
                    _arg_2.filterString = "core.playerNameTxt.GF";
                    Helpers.setTextfieldFormat(_arg_2, {
                        "color":11400447,
                        "bold":false,
                        "font":LanguageMgr.GetTranslation("songti")
                    }, true);
                    _arg_2.visible = true;
                    if (_arg_3)
                    {
                        _arg_3.visible = false;
                    };
                }
                else
                {
                    if (_arg_1.IsVIP)
                    {
                        if (_arg_3)
                        {
                            _arg_3.visible = true;
                        };
                        _arg_2.visible = false;
                    }
                    else
                    {
                        _arg_2.filterString = "core.playerNameTxt.GF2";
                        Helpers.setTextfieldFormat(_arg_2, {
                            "color":0,
                            "bold":false,
                            "font":LanguageMgr.GetTranslation("songti")
                        }, true);
                        _arg_2.visible = true;
                        if (_arg_3)
                        {
                            _arg_3.visible = false;
                        };
                    };
                };
            };
        }


    }
}//package ddt.utils

