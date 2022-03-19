// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//militaryrank.view.MilitaryIcon

package militaryrank.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.ITipedDisplay;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.manager.PlayerManager;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.StateManager;
    import militaryrank.MilitaryRankManager;
    import road7th.data.DictionaryData;
    import tofflist.TofflistModel;
    import ddt.manager.ServerConfigManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class MilitaryIcon extends Sprite implements ITipedDisplay, Disposeable 
    {

        private var _iconPic:ScaleFrameImage;
        private var _score:int;
        private var _tipDirctions:String;
        private var _tipGapH:int;
        private var _tipGapV:int;
        private var _tipStyle:String;
        private var _tipData:String;
        private var _size:int;
        private var _info:PlayerInfo;

        public function MilitaryIcon(_arg_1:PlayerInfo)
        {
            this.init();
            this.initView();
            this._info = _arg_1;
            this.initEvent();
        }

        private function init():void
        {
            this._tipStyle = "ddt.view.tips.OneLineTip";
            this._tipGapV = 10;
            this._tipGapH = 10;
            this._tipDirctions = "7,4,6,5";
            ShowTipManager.Instance.addTip(this);
        }

        private function initEvent():void
        {
            if (this._info.ID == PlayerManager.Instance.Self.ID)
            {
                this.buttonMode = true;
                this.addEventListener(MouseEvent.CLICK, this.__showMilitaryFrame);
            };
        }

        private function __showMilitaryFrame(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (StateManager.isInFight)
            {
                return;
            };
            MilitaryRankManager.Instance.show();
        }

        public function set Info(_arg_1:PlayerInfo):void
        {
            this._info = _arg_1;
        }

        public function setMilitary(_arg_1:int):void
        {
            var _local_2:DictionaryData;
            this._score = _arg_1;
            if (this._iconPic)
            {
                _local_2 = TofflistModel.Instance.getMilitaryLocalTopN();
                if (((_arg_1 < ServerConfigManager.instance.getMilitaryData()[12]) || (!(_local_2.hasKey(this._info.ID)))))
                {
                    this._iconPic.setFrame(MilitaryRankManager.Instance.getMilitaryFrameNum(_arg_1));
                }
                else
                {
                    if (this._score != ServerConfigManager.instance.getMilitaryData()[12])
                    {
                        this._iconPic.setFrame(MilitaryRankManager.Instance.getOtherMilitaryName(_local_2[this._info.ID][0])[1]);
                    }
                    else
                    {
                        this._iconPic.setFrame(12);
                    };
                };
            };
        }

        public function set ShowTips(_arg_1:Boolean):void
        {
            if ((!(_arg_1)))
            {
                ShowTipManager.Instance.removeTip(this);
            }
            else
            {
                ShowTipManager.Instance.addTip(this);
            };
        }

        public function setCusFrame(_arg_1:int):void
        {
            this._iconPic.setFrame(_arg_1);
        }

        private function initView():void
        {
            this._iconPic = ComponentFactory.Instance.creatComponentByStylename("militaryrank.Icon");
            addChild(this._iconPic);
        }

        public function get tipData():Object
        {
            var _local_1:String;
            var _local_2:DictionaryData = TofflistModel.Instance.getMilitaryLocalTopN();
            if (((this._score < ServerConfigManager.instance.getMilitaryData()[12]) || (!(_local_2.hasKey(this._info.ID)))))
            {
                _local_1 = ((((((LanguageMgr.GetTranslation("tank.menu.MilitaryScore") + ":") + MilitaryRankManager.Instance.getMilitaryRankInfo(this._score).Name) + "\n") + LanguageMgr.GetTranslation("tank.menu.MilitaryTxt")) + ":") + this._score);
            }
            else
            {
                _local_1 = ((((((LanguageMgr.GetTranslation("tank.menu.MilitaryScore") + ":") + MilitaryRankManager.Instance.getOtherMilitaryName(_local_2[this._info.ID][0])[0]) + "\n") + LanguageMgr.GetTranslation("tank.menu.MilitaryTxt")) + ":") + this._score);
            };
            return (_local_1);
        }

        public function set tipData(_arg_1:Object):void
        {
            this._tipData = (_arg_1 as String);
        }

        public function get tipDirctions():String
        {
            return (this._tipDirctions);
        }

        public function set tipDirctions(_arg_1:String):void
        {
            this._tipDirctions = _arg_1;
        }

        public function get tipGapH():int
        {
            return (0);
        }

        public function set tipGapH(_arg_1:int):void
        {
        }

        public function get tipGapV():int
        {
            return (0);
        }

        public function set tipGapV(_arg_1:int):void
        {
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
            return (null);
        }

        public function dispose():void
        {
            if (this._info.ID == PlayerManager.Instance.Self.ID)
            {
                this.removeEventListener(MouseEvent.CLICK, this.__showMilitaryFrame);
            };
            ShowTipManager.Instance.removeTip(this);
            ObjectUtils.disposeObject(this._iconPic);
            this._iconPic = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package militaryrank.view

