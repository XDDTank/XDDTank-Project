// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.common.FightToolBoxIcon

package ddt.view.common
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.core.ITipedDisplay;
    import road7th.data.DictionaryData;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.ui.ShowTipManager;
    import flash.events.MouseEvent;
    import flash.display.Bitmap;
    import ddt.manager.PlayerManager;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SoundManager;
    import fightToolBox.FightToolBoxController;

    public class FightToolBoxIcon extends Sprite implements Disposeable, ITipedDisplay 
    {

        public static const ICON_BITMAP:String = "asset.FightToolBoxIcon.Level_";

        private var _bitmapDic:DictionaryData;
        private var _tipDictions:String;
        private var _tipGapH:int;
        private var _tipGapV:int;
        private var _tipStyle:String;
        private var _bmContainer:Sprite;
        private var _tipData:Object;
        private var _clickEnable:Boolean = true;
        private var _playerInfo:PlayerInfo;

        public function FightToolBoxIcon()
        {
            this._bitmapDic = new DictionaryData();
            this._tipStyle = "core.FightToolBoxTips";
            this._tipGapH = 5;
            this._tipGapV = 5;
            this._tipDictions = "2,1,0";
            mouseChildren = true;
            mouseEnabled = false;
            this._bmContainer = new Sprite();
            this._bmContainer.buttonMode = true;
            addChild(this._bmContainer);
            ShowTipManager.Instance.addTip(this);
            addEventListener(MouseEvent.CLICK, this.__showVipFrame);
        }

        public function setClick(_arg_1:Boolean):void
        {
            this._bmContainer.buttonMode = _arg_1;
            this._clickEnable = _arg_1;
        }

        override public function get height():Number
        {
            return (this._bmContainer.height);
        }

        public function dispose():void
        {
            var _local_1:String;
            var _local_2:Bitmap;
            removeEventListener(MouseEvent.CLICK, this.__showVipFrame);
            ShowTipManager.Instance.removeTip(this);
            this.clearnDisplay();
            for (_local_1 in this._bitmapDic)
            {
                _local_2 = this._bitmapDic[_local_1];
                _local_2.bitmapData.dispose();
                delete this._bitmapDic[_local_1];
            };
            this._bitmapDic = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function setInfo(_arg_1:PlayerInfo):void
        {
            if (((_arg_1 == null) || ((!(PlayerManager.Instance.Self.ID == _arg_1.ID)) && (_arg_1.isFightVip == false))))
            {
                return;
            };
            this._playerInfo = _arg_1;
            this.tipData = this._playerInfo;
            this.updateView();
        }

        public function get tipData():Object
        {
            return (this._tipData);
        }

        public function set tipData(_arg_1:Object):void
        {
            this._tipData = _arg_1;
        }

        public function get tipDirctions():String
        {
            return (this._tipDictions);
        }

        public function set tipDirctions(_arg_1:String):void
        {
            this._tipDictions = _arg_1;
        }

        public function get tipGapH():int
        {
            return (this._tipGapH);
        }

        public function set tipGapH(_arg_1:int):void
        {
            this._tipGapH = _arg_1;
        }

        public function get tipGapV():int
        {
            return (this._tipGapV);
        }

        public function set tipGapV(_arg_1:int):void
        {
            this._tipGapV = _arg_1;
        }

        public function get tipStyle():String
        {
            return (this._tipStyle);
        }

        public function set tipStyle(_arg_1:String):void
        {
            this._tipStyle = _arg_1;
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        private function updateView():void
        {
            this.clearnDisplay();
            this.addBitmap();
        }

        private function addBitmap():void
        {
            this._bmContainer.addChild(this.creatTexpBitmap());
            addChild(this._bmContainer);
        }

        private function creatTexpBitmap():Bitmap
        {
            var _local_1:int = 3;
            _local_1 = ((_local_1 == 0) ? 1 : _local_1);
            if (this._bitmapDic[_local_1])
            {
                return (this._bitmapDic[_local_1]);
            };
            var _local_2:Bitmap = ComponentFactory.Instance.creatBitmap((ICON_BITMAP + _local_1.toString()));
            _local_2.smoothing = true;
            this._bitmapDic[_local_1] = _local_2;
            return (_local_2);
        }

        private function __showVipFrame(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._clickEnable)
            {
                FightToolBoxController.instance.show();
            };
        }

        private function clearnDisplay():void
        {
            while (this._bmContainer.numChildren > 0)
            {
                this._bmContainer.removeChildAt(0);
            };
        }


    }
}//package ddt.view.common

