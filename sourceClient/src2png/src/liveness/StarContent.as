// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//liveness.StarContent

package liveness
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.DisplayObject;
    import ddt.view.tips.OneLineTipUseHtmlText;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class StarContent extends Sprite implements Disposeable 
    {

        private var _type:uint;
        private var _index:uint;
        private var _enable:Boolean;
        private var _starObj:DisplayObject;
        private var _starTip:OneLineTipUseHtmlText;

        public function StarContent(_arg_1:uint)
        {
            this._index = _arg_1;
            this._type = LivenessAwardManager.Instance.model.statusList[this._index];
            this.createBmp();
            this.addEvent();
            addChild(this._starObj);
        }

        private function createBmp():void
        {
            this.enable = false;
            switch (this._type)
            {
                case LivenessModel.NOT_THE_TIME:
                    this._starObj = ComponentFactory.Instance.creatBitmap("asset.liveness.starNotSign");
                    return;
                case LivenessModel.DAY_PASS:
                    this._starObj = ComponentFactory.Instance.creatBitmap("asset.liveness.starNormal");
                    this._starObj.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                    return;
                case LivenessModel.NOT_GET_AWARD:
                    this._starObj = ComponentFactory.Instance.creat("asset.liveness.starAppear");
                    this._starObj.addEventListener(Event.COMPLETE, this.__starAppear);
                    (this._starObj as MovieClip).gotoAndPlay(2);
                    return;
                case LivenessModel.HAS_GET_AWARD:
                    this._starObj = ComponentFactory.Instance.creatBitmap("asset.liveness.starNormal");
                    return;
            };
        }

        private function __starAppear(_arg_1:Event):void
        {
            this.enable = true;
        }

        private function addEvent():void
        {
            this.addEventListener(MouseEvent.ROLL_OVER, this.__rollOver);
            this.addEventListener(MouseEvent.ROLL_OUT, this.__rollOut);
        }

        private function removeEvent():void
        {
            this.removeEventListener(MouseEvent.ROLL_OVER, this.__rollOver);
            this.removeEventListener(MouseEvent.ROLL_OUT, this.__rollOut);
        }

        private function __rollOver(_arg_1:MouseEvent):void
        {
            var _local_2:Point;
            if (this._starTip)
            {
                this._starTip.visible = true;
                LayerManager.Instance.addToLayer(this._starTip, LayerManager.GAME_TOP_LAYER);
                _local_2 = this.localToGlobal(new Point(0, 0));
                this._starTip.x = (_local_2.x + this.width);
                this._starTip.y = (_local_2.y + this.height);
            };
        }

        private function __rollOut(_arg_1:MouseEvent):void
        {
            if (this._starTip)
            {
                this._starTip.visible = false;
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._starObj);
            this._starObj = null;
            ObjectUtils.disposeObject(this._starTip);
            this._starTip = null;
        }

        public function set enable(_arg_1:Boolean):void
        {
            this._enable = _arg_1;
            if (_arg_1)
            {
                this.buttonMode = true;
                this.useHandCursor = true;
            }
            else
            {
                this.buttonMode = false;
                this.useHandCursor = false;
            };
        }

        public function get enable():Boolean
        {
            return (this._enable);
        }

        public function get index():uint
        {
            if (this._index == 6)
            {
                return (0);
            };
            if (this._index == 7)
            {
                return (7);
            };
            return (this._index + 1);
        }

        public function reflashStar():void
        {
            this._type = LivenessAwardManager.Instance.model.statusList[this._index];
            removeChild(this._starObj);
            if (this._starObj.hasEventListener(Event.COMPLETE))
            {
                this._starObj.removeEventListener(Event.COMPLETE, this.__starAppear);
            };
            this._starObj = null;
            this.createBmp();
            addChild(this._starObj);
        }

        public function set type(_arg_1:uint):void
        {
            this._type = _arg_1;
        }


    }
}//package liveness

