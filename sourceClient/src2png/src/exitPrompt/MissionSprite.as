// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//exitPrompt.MissionSprite

package exitPrompt
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleUpDownImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.TiledImage;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class MissionSprite extends Sprite implements Disposeable 
    {

        private const BG_X:int = -1;
        public const BG_Y:int = -72;
        private const BG_WIDTH:int = 290;

        public var oldHeight:int;
        private var _arr:Array;
        private var _bg:ScaleUpDownImage;

        public function MissionSprite(_arg_1:Array)
        {
            this._arr = _arg_1;
            this._init(this._arr);
        }

        private function _init(_arg_1:Array):void
        {
            var _local_3:FilterFrameText;
            var _local_4:Bitmap;
            var _local_5:FilterFrameText;
            var _local_6:TiledImage;
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                _local_3 = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.MissionText0");
                _local_4 = ComponentFactory.Instance.creatBitmap("exit.ExitMission.Arrow");
                _local_3.text = (_arg_1[_local_2][0] as String);
                _local_3.y = ((((_local_3.height * _local_2) * 3) / 2) - 6);
                _local_4.x = 16;
                _local_4.y = _local_3.y;
                addChild(_local_3);
                addChild(_local_4);
                _local_5 = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.MissionText1");
                _local_5.text = (_arg_1[_local_2][1] as String);
                _local_5.y = ((((_local_5.height * _local_2) * 3) / 2) - 4);
                addChild(_local_5);
                _local_6 = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.item.line");
                _local_6.y = ((((_local_3.height * _local_2) * 3) / 2) + 16);
                addChild(_local_6);
                _local_2++;
            };
            this.oldHeight = height;
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ExitPromptFrame.BtInfoBG");
            this._bg.width = this.BG_WIDTH;
            this._bg.height = (this.height - this.BG_Y);
            this._bg.x = this.BG_X;
            this._bg.y = this.BG_Y;
            addChild(this._bg);
            setChildIndex(this._bg, 0);
        }

        public function get content():Array
        {
            return (this._arr);
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
        }


    }
}//package exitPrompt

