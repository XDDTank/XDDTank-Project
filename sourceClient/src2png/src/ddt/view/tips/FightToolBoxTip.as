// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.FightToolBoxTip

package ddt.view.tips
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.tip.ITip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.geom.Point;
    import ddt.data.player.SelfInfo;
    import ddt.manager.TimeManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class FightToolBoxTip extends BaseTip implements Disposeable, ITip 
    {

        private var _bg:ScaleBitmapImage;
        private var _level:FilterFrameText;
        private var _showMsg:FilterFrameText;
        private var _showMsgBg:Point;


        override public function get width():Number
        {
            return (this._bg.width);
        }

        override public function get tipData():Object
        {
            return (_tipData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            var _local_2:Date;
            var _local_3:Date;
            var _local_4:int;
            if (_arg_1)
            {
                if ((_arg_1 is SelfInfo))
                {
                    _local_2 = new Date((_arg_1.fightVipStartTime.getTime() + ((_arg_1.fightVipValidDate * 60) * 1000)));
                    _local_3 = TimeManager.Instance.Now();
                    if ((!(_arg_1.isFightVip)))
                    {
                        this._showMsg.htmlText = LanguageMgr.GetTranslation("FightToolBoxFrame.vip.no");
                    }
                    else
                    {
                        _local_4 = int(Math.ceil((((((_local_2.getTime() - _local_3.getTime()) / 1000) / 60) / 60) / 24)));
                        if (_local_4 <= 0)
                        {
                            _local_4 = 1;
                        };
                        this._showMsg.htmlText = LanguageMgr.GetTranslation("ddt.fightToolBox.iconTips", _local_4);
                    };
                }
                else
                {
                    this._showMsg.htmlText = LanguageMgr.GetTranslation("ddt.fightToolBox.iconTipsOthers");
                };
                this._bg.width = (this._showMsg.width + 15);
                this._bg.height = (this._showMsg.height + 15);
            }
            else
            {
                this.visible = false;
            };
        }

        override protected function init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
            this._level = ComponentFactory.Instance.creatComponentByStylename("fightToolBox.tips.level");
            this._showMsg = ComponentFactory.Instance.creatComponentByStylename("fightToolBox.tips.showMsg");
            this._showMsgBg = ComponentFactory.Instance.creatCustomObject("fightToolBox.tips.showMsgBg");
        }

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._bg);
            addChild(this._level);
            addChild(this._showMsg);
            mouseChildren = false;
            mouseEnabled = false;
        }

        override public function dispose():void
        {
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
                this._bg = null;
            };
            if (this._level)
            {
                ObjectUtils.disposeObject(this._level);
                this._level = null;
            };
            if (this._showMsg)
            {
                ObjectUtils.disposeObject(this._showMsg);
                this._showMsg = null;
            };
            if (this._showMsgBg)
            {
                ObjectUtils.disposeObject(this._showMsgBg);
                this._showMsgBg = null;
            };
        }


    }
}//package ddt.view.tips

