﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.WishView

package game.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import game.model.LocalPlayer;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.SelectedButton;
    import ddt.manager.SharedManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import ddt.manager.ServerConfigManager;
    import ddt.manager.LanguageMgr;
    import game.GameManager;
    import flash.events.MouseEvent;
    import ddt.events.LivingEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.events.SharedEvent;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import com.greensock.TweenMax;
    import com.greensock.easing.Elastic;
    import ddt.manager.MessageTipManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.utils.ObjectUtils;

    public class WishView extends Sprite implements Disposeable 
    {

        public static const WISH_CLICK:String = "wishClick";

        private const MOVE_DISTANCE:int = 150;

        private var _wishButtom:BaseButton;
        private var _timesRecording:Number;
        private var _text:FilterFrameText;
        private var _self:LocalPlayer;
        private var _level:int;
        private var _isFirstWish:Boolean;
        private var _textBg:ScaleBitmapImage;
        private var _panelBtn:SelectedButton;
        private var _useReduceEnerge:int;
        private var _freeTimes:int;

        public function WishView(_arg_1:LocalPlayer, _arg_2:Boolean)
        {
            var _local_3:int;
            super();
            this._self = _arg_1;
            this._level = this._self.playerInfo.Grade;
            this._timesRecording = 1;
            this._isFirstWish = SharedManager.Instance.isFirstWish;
            this._wishButtom = ComponentFactory.Instance.creatComponentByStylename("wishView.wishBtn");
            this._wishButtom.enable = false;
            if (PlayerManager.Instance.Self.IsVIP)
            {
                _local_3 = PlayerManager.Instance.Self.VIPLevel;
                this._useReduceEnerge = int(ServerConfigManager.instance.VIPPayAimEnergy[(_local_3 - 1)]);
            }
            else
            {
                this._useReduceEnerge = ServerConfigManager.instance.PayAimEnergy;
            };
            this._wishButtom.tipData = LanguageMgr.GetTranslation("ddt.games.wishofdd", this._useReduceEnerge);
            addChild(this._wishButtom);
            this._textBg = ComponentFactory.Instance.creatComponentByStylename("core.wishView.bg");
            addChild(this._textBg);
            this._panelBtn = ComponentFactory.Instance.creatComponentByStylename("core.wishView.panelBtn");
            this._panelBtn.tipData = LanguageMgr.GetTranslation("ddt.games.wishofdd", this._useReduceEnerge);
            addChild(this._panelBtn);
            this._text = ComponentFactory.Instance.creatComponentByStylename("wishView.spandTicket");
            this.freeTimes = GameManager.Instance.Current.selfGamePlayer.wishFreeTime;
            addChild(this._text);
            this.addEvent();
            this.initPosition(_arg_2);
            this.stateInit();
        }

        protected function addEvent():void
        {
            this._wishButtom.addEventListener(MouseEvent.CLICK, this.__wishBtnClick);
            this._panelBtn.addEventListener(MouseEvent.CLICK, this.__movePanle);
            this._self.addEventListener(LivingEvent.ENERGY_CHANGED, this.__ennergChange);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_CHANGE, this.__playerChange);
            SharedManager.Instance.addEventListener(SharedEvent.TRANSPARENTCHANGED, this.__transparentChanged);
        }

        private function stateInit():void
        {
            if (this._self.isLiving)
            {
                if ((((PlayerManager.Instance.Self.Money > this.needMoney) || (this.freeTimes > 0)) && (this._self.energy > this._useReduceEnerge)))
                {
                    this._wishButtom.enable = true;
                    this._text.setFrame(1);
                }
                else
                {
                    this._wishButtom.enable = false;
                    this._text.setFrame(2);
                };
            };
        }

        protected function __transparentChanged(_arg_1:Event):void
        {
            if (parent)
            {
                if (SharedManager.Instance.propTransparent)
                {
                    alpha = 0.5;
                }
                else
                {
                    alpha = 1;
                };
            };
        }

        private function __movePanle(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._panelBtn.selected)
            {
                TweenMax.to(this, 0.5, {
                    "x":-(this.MOVE_DISTANCE),
                    "ease":Elastic.easeOut
                });
            }
            else
            {
                TweenMax.to(this, 0.5, {
                    "x":0,
                    "ease":Elastic.easeOut
                });
            };
            SharedManager.Instance.isWishPop = this._panelBtn.selected;
            SharedManager.Instance.save();
        }

        protected function removeEvent():void
        {
            this._wishButtom.removeEventListener(MouseEvent.CLICK, this.__wishBtnClick);
            this._panelBtn.removeEventListener(MouseEvent.CLICK, this.__movePanle);
            this._self.removeEventListener(LivingEvent.ENERGY_CHANGED, this.__ennergChange);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_CHANGE, this.__playerChange);
            SharedManager.Instance.removeEventListener(SharedEvent.TRANSPARENTCHANGED, this.__transparentChanged);
        }

        public function get freeTimes():int
        {
            return (this._freeTimes);
        }

        public function set freeTimes(_arg_1:int):void
        {
            this._freeTimes = _arg_1;
            if (this._freeTimes > 0)
            {
                this._text.text = LanguageMgr.GetTranslation("ddt.games.spandFreeTimes", this._freeTimes);
            }
            else
            {
                this._text.text = LanguageMgr.GetTranslation("ddt.games.spandTicket", this.needMoney);
            };
        }

        private function __playerChange(_arg_1:CrazyTankSocketEvent):void
        {
            this.stateInit();
        }

        private function __ennergChange(_arg_1:LivingEvent):void
        {
            if (this._wishButtom.enable)
            {
                this.stateInit();
            };
        }

        protected function get needMoney():Number
        {
            return (int(((0.1 * this._level) * Math.pow(2, (this._timesRecording - 1)))) + 2);
        }

        protected function __wishBtnClick(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            SoundManager.instance.play("008");
            if (this._isFirstWish)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.games.FirstWish"));
                SharedManager.Instance.isFirstWish = false;
                SharedManager.Instance.save();
            };
            if (((this._timesRecording >= 10) && (PlayerManager.Instance.Self.bagLocked)))
            {
                BaglockedManager.Instance.show();
            }
            else
            {
                if (((this._self.isLiving) && (this._self.isAttacking)))
                {
                    SocketManager.Instance.out.sendWish();
                    if (this._freeTimes <= 0)
                    {
                        this._timesRecording++;
                    };
                    this._wishButtom.enable = false;
                    this._self.energy = (this._self.energy - this._useReduceEnerge);
                    dispatchEvent(new Event("wishClick"));
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.games.cannotuse"));
                };
            };
        }

        private function initPosition(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.x = -(this.MOVE_DISTANCE);
                this._panelBtn.selected = true;
            }
            else
            {
                this._panelBtn.selected = false;
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._wishButtom)
            {
                ObjectUtils.disposeObject(this._wishButtom);
                this._wishButtom = null;
            };
            if (this._text)
            {
                ObjectUtils.disposeObject(this._text);
                this._text = null;
            };
        }


    }
}//package game.view
