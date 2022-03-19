// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.common.VipLevelIcon

package ddt.view.common
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.ITipedDisplay;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.data.VipConfigInfo;
    import ddt.manager.PlayerManager;
    import ddt.manager.VipPrivilegeConfigManager;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import ddt.data.player.BasePlayer;
    import ddt.manager.SoundManager;
    import ddt.manager.StateManager;
    import vip.VipController;
    import com.pickgliss.utils.DisplayUtils;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class VipLevelIcon extends Sprite implements ITipedDisplay, Disposeable 
    {

        public static const SIZE_BIG:int = 0;
        public static const SIZE_SMALL:int = 1;
        private static const LEVEL_ICON_CLASSPATH:String = "asset.vipIcon.vipLevel_";

        private var _seniorIcon:ScaleFrameImage;
        private var _level:int = 1;
        private var _type:int = 0;
        private var _isVip:Boolean = false;
        private var _vipExp:int = 0;
        private var _tipDirctions:String;
        private var _tipGapH:int;
        private var _tipGapV:int;
        private var _tipStyle:String;
        private var _tipData:String;
        private var _size:int;

        public function VipLevelIcon()
        {
            this._tipStyle = "ddt.view.tips.OneLineTip";
            this._tipGapV = 10;
            this._tipGapH = 10;
            this._tipDirctions = "7,4,6,5";
            this._size = SIZE_SMALL;
            this._seniorIcon = ComponentFactory.Instance.creatComponentByStylename("core.SeniorVipLevelIcon");
            buttonMode = true;
            ShowTipManager.Instance.addTip(this);
        }

        public function setInfo(_arg_1:BasePlayer, _arg_2:Boolean=true, _arg_3:Boolean=false):void
        {
            var _local_4:VipConfigInfo;
            var _local_5:int;
            if (_arg_1.ID == PlayerManager.Instance.Self.ID)
            {
                this._level = PlayerManager.Instance.Self.VIPLevel;
                this._isVip = PlayerManager.Instance.Self.IsVIP;
                this._vipExp = PlayerManager.Instance.Self.VIPExp;
            }
            else
            {
                this._level = _arg_1.VIPLevel;
                this._isVip = _arg_1.IsVIP;
                this._vipExp = _arg_1.VIPExp;
            };
            _local_4 = VipPrivilegeConfigManager.Instance.getById(0);
            if (_arg_1.ID == PlayerManager.Instance.Self.ID)
            {
                if (_arg_2)
                {
                    buttonMode = (!(_arg_3));
                    if (((this._isVip) && (_local_4)))
                    {
                        if (_arg_1.VIPLevel < 10)
                        {
                            _local_5 = (_local_4[("Level" + (this._level + 1))] - _arg_1.VIPExp);
                            this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.upGradDays", _local_5, (this._level + 1));
                        }
                        else
                        {
                            this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.upGradFull");
                        };
                    }
                    else
                    {
                        if (((_arg_1.VIPLevel > 0) && (_arg_1.VIPtype == 0)))
                        {
                            this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipView.expiredTrue");
                        }
                        else
                        {
                            this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipFrame.youarenovip");
                        };
                    };
                }
                else
                {
                    mouseEnabled = false;
                    mouseChildren = false;
                };
                if ((!(_arg_3)))
                {
                    addEventListener(MouseEvent.CLICK, this.__showVipFrame);
                };
            }
            else
            {
                removeEventListener(MouseEvent.CLICK, this.__showVipFrame);
                if (_arg_2)
                {
                    if (this._isVip)
                    {
                        this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.otherVipTip", _arg_1.VIPLevel);
                    }
                    else
                    {
                        this._tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.otherNoVipTip");
                    };
                }
                else
                {
                    mouseEnabled = false;
                    mouseChildren = false;
                };
            };
            this._type = _arg_1.VIPtype;
            this.updateIcon();
        }

        private function __showVipFrame(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (StateManager.isInFight)
            {
                return;
            };
            VipController.instance.show();
        }

        private function updateIcon():void
        {
            DisplayUtils.removeDisplay(this._seniorIcon);
            if (this._size == SIZE_SMALL)
            {
                if (((this._isVip) || (this._level > 0)))
                {
                    this._seniorIcon.setFrame((this._level + 14));
                    addChild(this._seniorIcon);
                }
                else
                {
                    this._seniorIcon.setFrame(14);
                    addChild(this._seniorIcon);
                };
            }
            else
            {
                if (this._size == SIZE_BIG)
                {
                    if (((this._isVip) || (this._level > 0)))
                    {
                        this._seniorIcon.setFrame((this._level + 1));
                        addChild(this._seniorIcon);
                    }
                    else
                    {
                        this._seniorIcon.setFrame(1);
                        addChild(this._seniorIcon);
                    };
                };
            };
        }

        public function setSize(_arg_1:int):void
        {
            this._size = _arg_1;
            this.updateIcon();
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
            return (0);
        }

        public function get tipGapH():int
        {
            return (0);
        }

        public function set tipStyle(_arg_1:String):void
        {
            this._tipStyle = _arg_1;
        }

        public function set tipData(_arg_1:Object):void
        {
            this._tipData = (_arg_1 as String);
        }

        public function set tipDirctions(_arg_1:String):void
        {
        }

        public function set tipGapV(_arg_1:int):void
        {
        }

        public function set tipGapH(_arg_1:int):void
        {
        }

        public function get tipWidth():int
        {
            return (0);
        }

        public function set tipWidth(_arg_1:int):void
        {
        }

        public function asDisplayObject():DisplayObject
        {
            return (null);
        }

        public function dispose():void
        {
            ShowTipManager.Instance.removeTip(this);
            removeEventListener(MouseEvent.CLICK, this.__showVipFrame);
            ObjectUtils.disposeObject(this._seniorIcon);
            this._seniorIcon = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.common

