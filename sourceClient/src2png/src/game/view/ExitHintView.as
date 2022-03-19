// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.ExitHintView

package game.view
{
    import com.pickgliss.ui.controls.Frame;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import ddt.manager.LanguageMgr;
    import flash.text.TextFieldAutoSize;
    import com.pickgliss.ui.LayerManager;

    public class ExitHintView extends Frame 
    {

        public function ExitHintView(_arg_1:String, _arg_2:String, _arg_3:Boolean=true, _arg_4:Function=null, _arg_5:Function=null, _arg_6:String=null, _arg_7:String=null, _arg_8:Number=0)
        {
        }

        public static function show(_arg_1:String, _arg_2:String, _arg_3:Boolean=true, _arg_4:Function=null, _arg_5:Function=null, _arg_6:Boolean=true, _arg_7:String=null, _arg_8:String=null, _arg_9:Number=0, _arg_10:Boolean=true):Frame
        {
            var _local_12:TextField;
            var _local_11:TextFormat = new TextFormat("Arial", 12, 0xFF0000);
            _local_12 = new TextField();
            _local_12.defaultTextFormat = _local_11;
            _local_12.text = LanguageMgr.GetTranslation("tank.view.ExitHint.hint.text");
            _local_12.autoSize = TextFieldAutoSize.LEFT;
            _local_12.x = 48;
            _local_12.y = 83;
            var _local_13:Frame = new ExitHintView(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_7, _arg_8, _arg_9);
            LayerManager.Instance.addToLayer(_local_13, LayerManager.GAME_DYNAMIC_LAYER);
            _local_13.addChild(_local_12);
            return (_local_13);
        }


    }
}//package game.view

