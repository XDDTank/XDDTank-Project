// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossRoomTotalInfoView

package worldboss.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import worldboss.WorldBossManager;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import com.pickgliss.toplevel.StageReferance;
    import worldboss.player.RankingPersonInfo;
    import com.pickgliss.utils.DisplayUtils;
    import com.pickgliss.utils.ObjectUtils;

    public class WorldBossRoomTotalInfoView extends Sprite implements Disposeable 
    {

        private var _totalInfoBg:Bitmap;
        private var _totalInfo_time:FilterFrameText;
        private var _totalInfo_currentDamage:FilterFrameText;
        private var _totalInfo_currentScore:FilterFrameText;
        private var _totalInfo_timeTxt:FilterFrameText;
        private var _totalInfo_currentDamageTxt:FilterFrameText;
        private var _totalInfo_currentScoreTxt:FilterFrameText;
        private var _txtArr:Array;
        private var _show_totalInfoBtnIMG:ScaleFrameImage;
        private var _open_show:Boolean = true;
        private var _show_totalInfoBtn:SimpleBitmapButton;

        public function WorldBossRoomTotalInfoView()
        {
            this._txtArr = new Array();
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            this._totalInfoBg = ComponentFactory.Instance.creatBitmap("worldBossRoom.totalInfoBg");
            addChild(this._totalInfoBg);
            this.creatTxtInfo();
            this._show_totalInfoBtn = ComponentFactory.Instance.creatComponentByStylename("worldBossRoom.showTotalBtn");
            addChild(this._show_totalInfoBtn);
            this._open_show = true;
            this._show_totalInfoBtnIMG = ComponentFactory.Instance.creatComponentByStylename("asset.worldBossRoom.showTotalBtnIMG");
            this._show_totalInfoBtnIMG.setFrame(1);
            this._show_totalInfoBtn.addChild(this._show_totalInfoBtnIMG);
        }

        private function creatTxtInfo():void
        {
            var _local_2:FilterFrameText;
            this._totalInfo_time = ComponentFactory.Instance.creatComponentByStylename("worldBossRoom.totalInfo.time");
            this._totalInfo_currentDamage = ComponentFactory.Instance.creatComponentByStylename("worldBossRoom.totalInfo.currentDamage");
            this._totalInfo_currentScore = ComponentFactory.Instance.creatComponentByStylename("worldBossRoom.totalInfo.currentScore");
            this._totalInfo_timeTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossRoom.totalInfo.timeTxt");
            this._totalInfo_currentDamageTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossRoom.totalInfo.currentDamageTxt");
            this._totalInfo_currentScoreTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossRoom.totalInfo.currentScoreTxt");
            addChild(this._totalInfo_time);
            addChild(this._totalInfo_currentDamage);
            addChild(this._totalInfo_currentScore);
            addChild(this._totalInfo_timeTxt);
            addChild(this._totalInfo_currentDamageTxt);
            addChild(this._totalInfo_currentScoreTxt);
            this._totalInfo_timeTxt.text = LanguageMgr.GetTranslation("worldboss.totalInfo.time");
            this._totalInfo_currentDamageTxt.text = LanguageMgr.GetTranslation("worldboss.totalInfo.currentDamge");
            this._totalInfo_currentScoreTxt.text = LanguageMgr.GetTranslation("worldboss.totalInfo.currentScore");
            var _local_1:int;
            while (_local_1 < 20)
            {
                if (_local_1 < 3)
                {
                    _local_2 = ComponentFactory.Instance.creat(("worldBossRoom.rankingTxt.No" + (_local_1 + 1)));
                }
                else
                {
                    if (_local_1 < 10)
                    {
                        _local_2 = ComponentFactory.Instance.creat("worldBossRoom.rankingTxt.NoOtherLeft");
                    }
                    else
                    {
                        if (_local_1 < 13)
                        {
                            _local_2 = ComponentFactory.Instance.creat(("worldBossRoom.rankingTxt.No" + (_local_1 + 1)));
                        }
                        else
                        {
                            _local_2 = ComponentFactory.Instance.creat("worldBossRoom.rankingTxt.NoOtherRight");
                        };
                    };
                };
                _local_2.y = (_local_2.y + (int((_local_1 % 10)) * 24));
                addChild(_local_2);
                this._txtArr.push(_local_2);
                _local_1++;
            };
            if (WorldBossManager.Instance.bossInfo.fightOver)
            {
                this._txtArr[0].text = LanguageMgr.GetTranslation("worldboss.ranking.over");
            }
            else
            {
                this._txtArr[0].text = LanguageMgr.GetTranslation("worldbossRoom.ranking.proploading");
            };
        }

        private function addEvent():void
        {
            this._show_totalInfoBtn.addEventListener(MouseEvent.CLICK, this.__showTotalInfo);
            WorldBossManager.Instance.addEventListener(Event.CHANGE, this.__onUpdata);
        }

        protected function __onUpdata(_arg_1:Event):void
        {
            this.updata_yourSelf_damage();
        }

        private function removeEvent():void
        {
            if (this._show_totalInfoBtn)
            {
                this._show_totalInfoBtn.removeEventListener(MouseEvent.CLICK, this.__showTotalInfo);
            };
            WorldBossManager.Instance.removeEventListener(Event.CHANGE, this.__onUpdata);
        }

        private function __showTotalInfo(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._show_totalInfoBtnIMG.setFrame(((this._open_show) ? 2 : 1));
            addEventListener(Event.ENTER_FRAME, this.__totalViewShowOrHide);
        }

        private function __totalViewShowOrHide(_arg_1:Event):void
        {
            if (this._open_show)
            {
                this.x = (this.x + 20);
                if (this.x >= (StageReferance.stageWidth - 25))
                {
                    removeEventListener(Event.ENTER_FRAME, this.__totalViewShowOrHide);
                    this.x = (StageReferance.stageWidth - 46);
                    this._open_show = (!(this._open_show));
                };
            }
            else
            {
                this.x = (this.x - 20);
                if (this.x <= (StageReferance.stageWidth - this.width))
                {
                    removeEventListener(Event.ENTER_FRAME, this.__totalViewShowOrHide);
                    this.x = ((StageReferance.stageWidth - this.width) - 12);
                    this._open_show = (!(this._open_show));
                };
            };
        }

        public function updata_yourSelf_damage():void
        {
            if (this._totalInfo_currentDamage)
            {
                this._totalInfo_currentDamage.text = WorldBossManager.Instance.bossInfo.myPlayerVO.myDamage.toString();
            };
            if (this._totalInfo_currentScore)
            {
                this._totalInfo_currentScore.text = WorldBossManager.Instance.bossInfo.myPlayerVO.myHonor.toString();
            };
        }

        public function setTimeCount(_arg_1:int):void
        {
            this._totalInfo_time.text = ((((this.setFormat(int((_arg_1 / 3600))) + ":") + this.setFormat(int(((_arg_1 / 60) % 60)))) + ":") + this.setFormat(int((_arg_1 % 60))));
        }

        public function updataRanking(_arg_1:Array):void
        {
            var _local_3:RankingPersonInfo;
            var _local_4:String;
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                _local_3 = (_arg_1[_local_2] as RankingPersonInfo);
                _local_4 = DisplayUtils.subStringByLength(this._txtArr[_local_2], _local_3.name, 80);
                this._txtArr[_local_2].text = (((_local_2 + 1) + ".") + _local_4);
                this._txtArr[(_local_2 + 10)].text = (((_local_3.damage + "(") + _local_3.getPercentage(WorldBossManager.Instance.bossInfo.total_Blood)) + ")");
                _local_2++;
            };
        }

        private function testshowRanking():void
        {
            var _local_1:int;
            while (_local_1 < 10)
            {
                this._txtArr[_local_1].text = (((_local_1 + 1) + ".哈王00") + _local_1);
                this._txtArr[(_local_1 + 10)].text = ((((9 - _local_1) * 3) * 10000) + "(2.152%)");
                _local_1++;
            };
        }

        public function restTimeInfo():void
        {
            this._totalInfo_time.text = "00:00:00";
        }

        private function setFormat(_arg_1:int):String
        {
            var _local_2:String = _arg_1.toString();
            if (_arg_1 < 10)
            {
                _local_2 = ("0" + _local_2);
            };
            return (_local_2);
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                this.parent.removeChild(this);
            };
            this.removeEvent();
            this._totalInfoBg = null;
            this._totalInfo_time = null;
            this._totalInfo_currentDamage = null;
            this._totalInfoBg = null;
            this._totalInfoBg = null;
            this._show_totalInfoBtn = null;
            this._show_totalInfoBtnIMG = null;
            this._txtArr = null;
        }


    }
}//package worldboss.view

