// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.view.DiamondOfWriting

package email.view
{
    import com.pickgliss.ui.core.ITipedDisplay;
    import ddt.data.goods.ItemTemplateInfo;
    import baglocked.BagLockedController;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ShowTipManager;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;

    public class DiamondOfWriting extends DiamondBase implements ITipedDisplay 
    {

        private var _cellGoodsID:int;
        private var _annex:ItemTemplateInfo;
        private var _bagLocked:BagLockedController;
        private var _tipStyle:String;
        private var _tipData:Object;
        private var _tipDirctions:String;
        private var _tipGapV:int;
        private var _tipGapH:int;

        public function DiamondOfWriting()
        {
            this.tipStyle = "ddt.view.tips.OneLineTip";
            this.tipDirctions = "0";
            this.tipGapV = 5;
            this.tipData = LanguageMgr.GetTranslation("tank.view.emailII.WritingView.annex.tip");
            ShowTipManager.Instance.addTip(this);
        }

        public function get annex():ItemTemplateInfo
        {
            return (this._annex);
        }

        public function set annex(_arg_1:ItemTemplateInfo):void
        {
            this._annex = _arg_1;
        }

        override protected function initView():void
        {
            super.initView();
            mouseEnabled = true;
            mouseChildren = true;
            buttonMode = true;
            _cell.visible = true;
            _cell.allowDrag = true;
            centerMC.x = -3;
            centerMC.y = 2;
            diamondBg.width = (diamondBg.height = 64);
        }

        override protected function update():void
        {
            if (this._annex == null)
            {
                centerMC.setFrame(1);
                centerMC.visible = true;
            };
            _cell.info = this._annex;
        }

        override protected function addEvent():void
        {
            _cell.addEventListener(Event.CHANGE, this.__dragInBag);
            addEventListener(MouseEvent.CLICK, this.__click);
        }

        override protected function removeEvent():void
        {
            _cell.removeEventListener(Event.CHANGE, this.__dragInBag);
            removeEventListener(MouseEvent.CLICK, this.__click);
        }

        public function setBagUnlock():void
        {
            _cell.clearLinkCell();
        }

        private function __click(_arg_1:MouseEvent):void
        {
            if (this._annex)
            {
                _cell.dragStart();
            };
        }

        private function __dragInBag(_arg_1:Event):void
        {
            this.annex = _cell.info;
            if (this.annex)
            {
            };
        }

        override public function dispose():void
        {
            super.dispose();
            this._annex = null;
            this._bagLocked;
            ShowTipManager.Instance.removeTip(this);
        }

        public function get tipStyle():String
        {
            return (this._tipStyle);
        }

        public function get tipData():Object
        {
            return (this._tipData);
        }

        public function get tipDirctions():String
        {
            return (this._tipDirctions);
        }

        public function get tipGapV():int
        {
            return (this._tipGapV);
        }

        public function get tipGapH():int
        {
            return (this._tipGapH);
        }

        public function set tipStyle(_arg_1:String):void
        {
            if (this._tipStyle == _arg_1)
            {
                return;
            };
            this._tipStyle = _arg_1;
        }

        public function set tipData(_arg_1:Object):void
        {
            if (this._tipData == _arg_1)
            {
                return;
            };
            this._tipData = _arg_1;
        }

        public function set tipDirctions(_arg_1:String):void
        {
            if (this._tipDirctions == _arg_1)
            {
                return;
            };
            this._tipDirctions = _arg_1;
        }

        public function set tipGapV(_arg_1:int):void
        {
            if (this._tipGapV == _arg_1)
            {
                return;
            };
            this._tipGapV = _arg_1;
        }

        public function set tipGapH(_arg_1:int):void
        {
            if (this._tipGapH == _arg_1)
            {
                return;
            };
            this._tipGapH = _arg_1;
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }


    }
}//package email.view

