// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.ChatFaceTip

package ddt.view.tips
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.tip.ITip;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import flash.display.DisplayObject;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import com.pickgliss.ui.vo.DirectionPos;

    public class ChatFaceTip extends Sprite implements Disposeable, ITip 
    {

        private var _minW:int;
        private var _minH:int;
        private var tip_txt:FilterFrameText;
        private var _tempData:Object;

        public function ChatFaceTip()
        {
            this.tip_txt = ComponentFactory.Instance.creat("core.ChatFaceTxt");
            this.tip_txt.border = true;
            this.tip_txt.background = true;
            this.tip_txt.backgroundColor = 0xFFFFFF;
            this.tip_txt.borderColor = 0x333333;
            this.tip_txt.mouseEnabled = false;
            this._minW = this.tip_txt.width;
            this.mouseChildren = false;
            this.init();
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this.tip_txt);
            this.tip_txt = null;
            ObjectUtils.disposeObject(this);
        }

        public function get tipData():Object
        {
            return (this._tempData);
        }

        public function set tipData(_arg_1:Object):void
        {
            if (((_arg_1 is String) && (!(_arg_1 == ""))))
            {
                this.tip_txt.width = this.updateW(String(_arg_1));
                this.tip_txt.text = String(_arg_1);
                this.visible = true;
            }
            else
            {
                this.visible = false;
            };
            this._tempData = _arg_1;
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        private function init():void
        {
            addChild(this.tip_txt);
        }

        private function updateW(_arg_1:String):int
        {
            var _local_2:TextField = new TextField();
            _local_2.autoSize = TextFieldAutoSize.LEFT;
            _local_2.text = _arg_1;
            if (_local_2.width < this._minW)
            {
                return (this._minW);
            };
            return (int((_local_2.width + 8)));
        }

        public function get currentDirectionPos():DirectionPos
        {
            return (null);
        }

        public function set currentDirectionPos(_arg_1:DirectionPos):void
        {
        }


    }
}//package ddt.view.tips

