// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.smallMap.SmallMapTitleBar

package game.view.smallMap
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import ddt.data.map.MissionInfo;
    import game.view.DungeonHelpView;
    import com.pickgliss.loader.DisplayLoader;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.TimeManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import room.RoomManager;
    import room.model.RoomInfo;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.manager.PathManager;
    import game.GameManager;
    import flash.display.Graphics;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.events.DungeonInfoEvent;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.events.RoomEvent;
    import setting.controll.SettingController;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.KeyboardEvent;
    import ddt.data.PathInfo;
    import ddt.manager.MessageTipManager;
    import flash.ui.Keyboard;
    import ddt.manager.GameInSocketOut;
    import com.pickgliss.utils.ObjectUtils;

    public class SmallMapTitleBar extends Sprite implements Disposeable 
    {

        private static const Ellipse:int = 4;

        private var _w:int = 162;
        private var _h:int = 23;
        private var _hardTxt:FilterFrameText;
        private var _back:BackBar;
        private var _exitBtn:SimpleBitmapButton;
        private var _settingBtn:SimpleBitmapButton;
        private var _turnButton:GameTurnButton;
        private var _mission:MissionInfo;
        private var _missionHelp:DungeonHelpView;
        private var _fieldNameLoader:DisplayLoader;
        private var _fieldName:Bitmap;
        private var alert:BaseAlerFrame;
        private var alert1:BaseAlerFrame;
        private var _startDate:Date;

        public function SmallMapTitleBar(_arg_1:MissionInfo)
        {
            this._startDate = TimeManager.Instance.Now();
            this.configUI();
            this.addEvent();
        }

        private function configUI():void
        {
            this._back = new BackBar();
            addChild(this._back);
            this._hardTxt = ComponentFactory.Instance.creatComponentByStylename("asset.game.smallMapHardTxt");
            addChild(this._hardTxt);
            this._settingBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.settingButton");
            this.setTip(this._settingBtn, LanguageMgr.GetTranslation("tank.game.ToolStripView.set"));
            addChild(this._settingBtn);
            this._exitBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.exitButton");
            this.setTip(this._exitBtn, LanguageMgr.GetTranslation("tank.game.ToolStripView.exit"));
            addChild(this._exitBtn);
            this._turnButton = ComponentFactory.Instance.creatCustomObject("GameTurnButton", [this]);
            var _local_1:int = RoomManager.Instance.current.type;
            if (((!(RoomManager.Instance.current.isDungeonType)) && (!(_local_1 == RoomInfo.FRESHMAN_ROOM))))
            {
                this._fieldNameLoader = LoadResourceManager.instance.createLoader(this.solveMapPath(), BaseLoader.BITMAP_LOADER);
                this._fieldNameLoader.addEventListener(LoaderEvent.COMPLETE, this.__onLoadComplete);
                LoadResourceManager.instance.startLoad(this._fieldNameLoader);
                this._back.tipStyle = "ddt.view.tips.PreviewTip";
                this._back.tipDirctions = "3,1";
                this._back.tipGapV = 5;
            };
            this.drawBackgound();
        }

        private function __onLoadComplete(_arg_1:LoaderEvent):void
        {
            this._fieldNameLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onLoadComplete);
            this._back.tipData = Bitmap(this._fieldNameLoader.content);
            ShowTipManager.Instance.addTip(this._back);
        }

        private function solveMapPath():String
        {
            var _local_1:String = (PathManager.SITE_MAIN + "image/map/");
            if (GameManager.Instance.Current.gameMode == 8)
            {
                return (_local_1 + "1133/icon.png");
            };
            var _local_2:int = GameManager.Instance.Current.mapIndex;
            if (RoomManager.Instance.current.mapId > 0)
            {
                _local_2 = RoomManager.Instance.current.mapId;
            };
            return (_local_1 + (_local_2.toString() + "/icon.png"));
        }

        public function get turnButton():GameTurnButton
        {
            return (this._turnButton);
        }

        private function setTip(_arg_1:SimpleBitmapButton, _arg_2:String):void
        {
            _arg_1.tipStyle = "ddt.view.tips.OneLineTip";
            _arg_1.tipDirctions = "3,6,1";
            _arg_1.tipGapV = 5;
            _arg_1.tipData = _arg_2;
        }

        private function drawBackgound():void
        {
            var _local_1:Graphics = graphics;
            _local_1.clear();
            _local_1.lineStyle(1, 0x333333, 1, true);
            _local_1.beginFill(0xFFFFFF, 0.8);
            _local_1.endFill();
            _local_1.moveTo(0, this._h);
            _local_1.lineTo(0, Ellipse);
            _local_1.curveTo(0, 0, Ellipse, 0);
            _local_1.lineTo((this._w - Ellipse), 0);
            _local_1.curveTo(this._w, 0, this._w, Ellipse);
            _local_1.lineTo(this._w, this._h);
            _local_1.endFill();
            this._exitBtn.x = ((this._w - this._exitBtn.width) - 2);
            this._settingBtn.x = ((this._exitBtn.x - this._settingBtn.width) - 2);
            this._turnButton.x = ((this._settingBtn.x - this._turnButton.width) - 2);
        }

        public function setBarrier(_arg_1:int, _arg_2:int):void
        {
            this._turnButton.text = ((_arg_1 + "/") + _arg_2);
        }

        private function removeEvent():void
        {
            this._exitBtn.removeEventListener(MouseEvent.CLICK, this.__exit);
            this._settingBtn.removeEventListener(MouseEvent.CLICK, this.__set);
            this._turnButton.removeEventListener(MouseEvent.CLICK, this.__turnFieldClick);
        }

        private function addEvent():void
        {
            this._exitBtn.addEventListener(MouseEvent.CLICK, this.__exit);
            this._settingBtn.addEventListener(MouseEvent.CLICK, this.__set);
            this._turnButton.addEventListener(MouseEvent.CLICK, this.__turnFieldClick);
        }

        private function __turnFieldClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            dispatchEvent(new DungeonInfoEvent(DungeonInfoEvent.DungeonHelpChanged));
            StageReferance.stage.focus = null;
        }

        private function __turnCountChanged(_arg_1:RoomEvent):void
        {
            this._turnButton.text = ((this._mission.turnCount + "/") + this._mission.maxTurnCount);
        }

        private function __set(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SettingController.Instance.switchVisible();
        }

        private function __exit(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (RoomManager.Instance.current.selfRoomPlayer.isViewer)
            {
                this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.game.ToolStripView.isExit"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                this.alert.addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
                this.alert.addEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
                return;
            };
            if (RoomManager.Instance.current.type == 5)
            {
                this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.game.ToolStripView.isExitLib"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                this.alert.addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
                this.alert.addEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
                return;
            };
            if ((!(GameManager.Instance.Current.selfGamePlayer.isLiving)))
            {
                if (GameManager.Instance.Current.selfGamePlayer.selfDieTimeDelayPassed)
                {
                    if (RoomManager.Instance.current.type < 2)
                    {
                        this.alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.game.ToolStripView.isExitPVP"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
                        this.alert1.addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
                        this.alert1.addEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
                    }
                    else
                    {
                        this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.game.ToolStripView.isExit"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                        this.alert.addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
                        this.alert.addEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
                    };
                };
                return;
            };
            var _local_2:Number = TimeManager.Instance.TimeSpanToNow(this._startDate).time;
            if (((!(RoomManager.Instance.current.isPVP())) && (!(RoomManager.Instance.current.type == RoomInfo.ARENA))))
            {
                this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.game.ToolStripView.isExit"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                this.alert.addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
                this.alert.addEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
                return;
            };
            if (_local_2 < PathInfo.SUCIDE_TIME)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ToolStripView.cannotExit"));
                return;
            };
            this.alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.game.ToolStripView.isExitPVP"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
            this.alert1.addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this.alert1.addEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
        }

        private function __onKeyDown(_arg_1:KeyboardEvent):void
        {
            _arg_1.stopImmediatePropagation();
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                (_arg_1.currentTarget as BaseAlerFrame).dispatchEvent(new FrameEvent(FrameEvent.ENTER_CLICK));
            }
            else
            {
                if (_arg_1.keyCode == Keyboard.ESCAPE)
                {
                    (_arg_1.currentTarget as BaseAlerFrame).dispatchEvent(new FrameEvent(FrameEvent.ESC_CLICK));
                };
            };
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            (_arg_1.target as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            (_arg_1.target as BaseAlerFrame).dispose();
            if (_arg_1.target == this.alert)
            {
                this.alert = null;
            }
            else
            {
                if (_arg_1.target == this.alert1)
                {
                    this.alert1 = null;
                };
            };
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                GameInSocketOut.sendGamePlayerExit();
            };
        }

        public function set enableExit(_arg_1:Boolean):void
        {
            this._exitBtn.enable = _arg_1;
        }

        override public function set width(_arg_1:Number):void
        {
            this._w = _arg_1;
            this._back.width = (_arg_1 + 0.5);
            this.drawBackgound();
        }

        override public function set height(_arg_1:Number):void
        {
            this._h = _arg_1;
            this.drawBackgound();
        }

        public function set title(_arg_1:String):void
        {
            this._hardTxt.text = _arg_1;
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._hardTxt)
            {
                ObjectUtils.disposeObject(this._hardTxt);
                this._hardTxt = null;
            };
            if (this._exitBtn)
            {
                ObjectUtils.disposeObject(this._exitBtn);
                this._exitBtn = null;
            };
            if (this._settingBtn)
            {
                ObjectUtils.disposeObject(this._settingBtn);
                this._settingBtn = null;
            };
            if (this._turnButton)
            {
                ObjectUtils.disposeObject(this._turnButton);
                this._turnButton = null;
            };
            if (this._back)
            {
                ObjectUtils.disposeObject(this._back);
                this._back = null;
            };
            if (this._fieldName)
            {
                ObjectUtils.disposeObject(this._fieldName);
            };
            this._fieldName = null;
            if (this._fieldNameLoader)
            {
                this._fieldNameLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onLoadComplete);
            };
            this._fieldNameLoader = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.smallMap

import flash.display.Sprite;
import com.pickgliss.ui.core.Disposeable;
import com.pickgliss.ui.core.ITipedDisplay;
import flash.display.Bitmap;
import com.pickgliss.ui.ComponentFactory;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.display.DisplayObject;
import com.pickgliss.utils.ObjectUtils;

class BackBar extends Sprite implements Disposeable, ITipedDisplay 
{

    /*private*/ var _w:Number = 1;
    /*private*/ var _back1:Bitmap;
    /*private*/ var _back2:Bitmap;
    /*private*/ var _back3:Bitmap;
    protected var _tipData:Object;
    protected var _tipDirction:String;
    protected var _tipGapV:int;
    protected var _tipGapH:int;
    protected var _tipStyle:String;

    public function BackBar()
    {
        this._back1 = ComponentFactory.Instance.creatBitmap("asset.game.smallmap.TitleBack1");
        this._back2 = ComponentFactory.Instance.creatBitmap("asset.game.smallmap.TitleBack2");
        this._back3 = ComponentFactory.Instance.creatBitmap("asset.game.smallmap.TitleBack3");
    }

    override public function set width(_arg_1:Number):void
    {
        this._w = _arg_1;
        this.draw();
    }

    /*private*/ function draw():void
    {
        var _local_1:Graphics = graphics;
        _local_1.clear();
        _local_1.beginBitmapFill(this._back1.bitmapData, null, true, true);
        _local_1.drawRect(0, 0, this._back1.width, this._back1.height);
        _local_1.endFill();
        _local_1.beginBitmapFill(this._back2.bitmapData, null, true, true);
        _local_1.drawRect(this._back1.width, 0, ((this._w - this._back1.width) - this._back3.width), this._back1.height);
        _local_1.endFill();
        var _local_2:Matrix = new Matrix();
        _local_2.tx = (this._w - this._back3.width);
        _local_1.beginBitmapFill(this._back3.bitmapData, _local_2, true, true);
        _local_1.drawRect((this._w - this._back3.width), 0, this._back3.width, this._back1.height);
        _local_1.endFill();
    }

    public function get tipData():Object
    {
        return (this._tipData);
    }

    public function set tipData(_arg_1:Object):void
    {
        if (this._tipData == _arg_1)
        {
            return;
        };
        this._tipData = _arg_1;
    }

    public function get tipDirctions():String
    {
        return (this._tipDirction);
    }

    public function set tipDirctions(_arg_1:String):void
    {
        if (this._tipDirction == _arg_1)
        {
            return;
        };
        this._tipDirction = _arg_1;
    }

    public function get tipGapV():int
    {
        return (this._tipGapV);
    }

    public function set tipGapV(_arg_1:int):void
    {
        if (this._tipGapV == _arg_1)
        {
            return;
        };
        this._tipGapV = _arg_1;
    }

    public function get tipGapH():int
    {
        return (this._tipGapH);
    }

    public function set tipGapH(_arg_1:int):void
    {
        if (this._tipGapH == _arg_1)
        {
            return;
        };
        this._tipGapH = _arg_1;
    }

    public function get tipStyle():String
    {
        return (this._tipStyle);
    }

    public function set tipStyle(_arg_1:String):void
    {
        if (this._tipStyle == _arg_1)
        {
            return;
        };
        this._tipStyle = _arg_1;
    }

    public function asDisplayObject():DisplayObject
    {
        return (this);
    }

    public function dispose():void
    {
        if (this._back1)
        {
            ObjectUtils.disposeObject(this._back1);
            this._back1 = null;
        };
        if (this._back2)
        {
            ObjectUtils.disposeObject(this._back2);
            this._back2 = null;
        };
        if (this._back3)
        {
            ObjectUtils.disposeObject(this._back3);
            this._back3 = null;
        };
        if (parent)
        {
            parent.removeChild(this);
        };
    }


}


