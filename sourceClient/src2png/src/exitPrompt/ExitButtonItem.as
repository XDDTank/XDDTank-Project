// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//exitPrompt.ExitButtonItem

package exitPrompt
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class ExitButtonItem extends Component 
    {

        private var _bt:ScaleFrameImage;
        private var _fontBg:ScaleFrameImage;
        public var fontBgBgUrl:String;
        public var coord:String;

        public function ExitButtonItem()
        {
            mouseChildren = false;
            buttonMode = true;
            this.initEvent();
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            var _local_1:Array = this.coord.split(/,/g);
            if ((!(this._bt)))
            {
                this._bt = ComponentFactory.Instance.creat("ExitPromptFrame.MissionBt");
            };
            this._bt.setFrame(2);
            if ((!(this._fontBg)))
            {
                this._fontBg = ComponentFactory.Instance.creat(this.fontBgBgUrl);
            };
            addChild(this._bt);
            addChild(this._fontBg);
            this._fontBg.x = _local_1[0];
            this._fontBg.y = _local_1[1];
            height = this._bt.height;
        }

        private function initEvent():void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandler);
        }

        private function removeEvent():void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandler);
        }

        private function __mouseOverHandler(_arg_1:MouseEvent):void
        {
            this._bt.setFrame(1);
            this._fontBg.setFrame(1);
        }

        private function __mouseOutHandler(_arg_1:MouseEvent):void
        {
            this._bt.setFrame(2);
            this._fontBg.setFrame(2);
        }

        public function setFrame(_arg_1:int):void
        {
            this._bt.setFrame(_arg_1);
        }

        override public function dispose():void
        {
            this.removeEvent();
            super.dispose();
            ObjectUtils.disposeObject(this._bt);
            ObjectUtils.disposeObject(this._fontBg);
            this._bt = null;
            this._fontBg = null;
        }


    }
}//package exitPrompt

