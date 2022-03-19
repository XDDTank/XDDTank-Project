// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.DungeonInfoView

package game.view
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.map.MissionInfo;
    import game.view.smallMap.GameTurnButton;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.ComponentFactory;
    import game.GameManager;
    import flash.geom.Point;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.events.GameEvent;
    import road7th.comm.PackageIn;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import com.greensock.TweenLite;

    public class DungeonInfoView extends Sprite 
    {

        private var _bg:Bitmap;
        private var _helpBtn:SimpleBitmapButton;
        private var _title1:FilterFrameText;
        private var _title2:FilterFrameText;
        private var _title3:FilterFrameText;
        private var _title4:FilterFrameText;
        private var _info1:FilterFrameText;
        private var _info2:FilterFrameText;
        private var _info3:FilterFrameText;
        private var _info4:FilterFrameText;
        private var _info:MissionInfo;
        private var _button:GameTurnButton;
        private var _container:DisplayObjectContainer;
        private var _sourceRect:Rectangle;
        private var _tweened:Boolean = false;
        private var _totalTrunTrainer:int = 100;
        private var _Vy:int;

        public function DungeonInfoView(_arg_1:GameTurnButton, _arg_2:DisplayObjectContainer)
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.game.missionInfoBgAsset");
            addChild(this._bg);
            this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfoViewButton");
            addChild(this._helpBtn);
            this._title1 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfoTitle1Txt");
            addChild(this._title1);
            this._title2 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfoTitle2Txt");
            addChild(this._title2);
            this._title3 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfoTitle3Txt");
            addChild(this._title3);
            this._title4 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfoTitle4Txt");
            addChild(this._title4);
            this._info1 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfo1Txt");
            addChild(this._info1);
            this._info2 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfo2Txt");
            addChild(this._info2);
            this._info3 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfo3Txt");
            addChild(this._info3);
            this._info4 = ComponentFactory.Instance.creatComponentByStylename("asset.game.missionInfo4Txt");
            addChild(this._info4);
            this._info = GameManager.Instance.Current.missionInfo;
            if (this._info.title1)
            {
                this._title1.text = this._info.title1;
            };
            if (this._info.title2)
            {
                this._title2.text = this._info.title2;
            };
            if (this._info.title3)
            {
                this._title3.text = this._info.title3;
            };
            if (this._info.title4)
            {
                this._title4.text = this._info.title4;
            };
            this._sourceRect = getBounds(this);
            var _local_3:Point = ComponentFactory.Instance.creatCustomObject("asset.game.barrierPos");
            this._sourceRect.x = _local_3.x;
            this._sourceRect.y = _local_3.y;
            this._container = _arg_2;
            this._button = _arg_1;
            this.addEvent();
        }

        private function addEvent():void
        {
            this._helpBtn.addEventListener(MouseEvent.CLICK, this.__openHelpHandler);
        }

        private function removeEvent():void
        {
            this._helpBtn.removeEventListener(MouseEvent.CLICK, this.__openHelpHandler);
        }

        private function __openHelpHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            dispatchEvent(new GameEvent(GameEvent.DungeonHelpVisibleChanged, true));
        }

        public function barrierInfoHandler(_arg_1:CrazyTankSocketEvent):void
        {
            this._info = GameManager.Instance.Current.missionInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            this._info.currentValue1 = _local_2.readInt();
            this._info.currentValue2 = _local_2.readInt();
            this._info.currentValue3 = _local_2.readInt();
            this._info.currentValue4 = _local_2.readInt();
            this.upView();
            dispatchEvent(new GameEvent(GameEvent.UPDATE_SMALLMAPVIEW, true));
        }

        public function trainerView(_arg_1:int):void
        {
            this._title1.text = "TRUN";
            if (_arg_1 == -1)
            {
                this._info1.text = "";
                return;
            };
            this._info1.text = ((_arg_1.toString() + "/") + this._totalTrunTrainer.toString());
            if (this._totalTrunTrainer == _arg_1)
            {
                StateManager.setState(StateType.MAIN);
            };
        }

        public function open():void
        {
            var _local_1:Rectangle;
            TweenLite.killTweensOf(this);
            _local_1 = this._button.getBounds(this._container);
            x = _local_1.x;
            y = _local_1.y;
            width = _local_1.width;
            height = _local_1.height;
            this._container.addChild(this);
            TweenLite.to(this, 0.3, {
                "x":this._sourceRect.x,
                "y":this._sourceRect.y,
                "width":this._sourceRect.width,
                "height":this._sourceRect.height
            });
        }

        private function closeComplete():void
        {
            if (parent)
            {
                parent.removeChild(this);
            };
            if (this._button)
            {
                this._button.shine();
            };
        }

        public function close():void
        {
            TweenLite.killTweensOf(this);
            x = this._sourceRect.x;
            y = this._sourceRect.y;
            width = this._sourceRect.width;
            height = this._sourceRect.height;
            var _local_1:Rectangle = this._button.getBounds(this._container);
            TweenLite.to(this, 0.3, {
                "x":_local_1.x,
                "y":_local_1.y,
                "width":_local_1.width,
                "height":_local_1.height,
                "onComplete":this.closeComplete
            });
            dispatchEvent(new GameEvent(GameEvent.DungeonHelpVisibleChanged, false));
        }

        private function upView():void
        {
            if (((!(this._info.currentValue1 == -1)) && (this._info.totalValue1 > 0)))
            {
                this._info1.text = ((this._info.currentValue1 + "/") + this._info.totalValue1);
            };
            if (((!(this._info.currentValue2 == -1)) && (this._info.totalValue2 > 0)))
            {
                this._info2.text = ((this._info.currentValue2 + "/") + this._info.totalValue2);
            };
            if (((!(this._info.currentValue3 == -1)) && (this._info.totalValue3 > 0)))
            {
                this._info3.text = ((this._info.currentValue3 + "/") + this._info.totalValue3);
            };
            if (((!(this._info.currentValue4 == -1)) && (this._info.totalValue4 > 0)))
            {
                this._info4.text = ((this._info.currentValue4 + "/") + this._info.totalValue4);
            };
        }

        public function dispose():void
        {
            TweenLite.killTweensOf(this);
            this.removeEvent();
            removeChild(this._bg);
            this._bg.bitmapData.dispose();
            this._bg = null;
            this._helpBtn.dispose();
            this._helpBtn = null;
            this._title1.dispose();
            this._title1 = null;
            this._title2.dispose();
            this._title2 = null;
            this._title3.dispose();
            this._title3 = null;
            this._title4.dispose();
            this._title4 = null;
            this._info1.dispose();
            this._info1 = null;
            this._info2.dispose();
            this._info2 = null;
            this._info3.dispose();
            this._info3 = null;
            this._info4.dispose();
            this._info4 = null;
            this._info = null;
            this._button = null;
            this._container = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view

