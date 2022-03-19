// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//arena.view.ArenaInformationView

package arena.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import arena.ArenaModel;
    import arena.ArenaManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.greensock.TweenLite;
    import com.pickgliss.utils.ObjectUtils;

    public class ArenaInformationView extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _lifeFlag:LifeFlagIcon;
        private var _helpBtn:BaseButton;
        private var _expandBtn:ScaleFrameImage;
        private var _lifeTxt:FilterFrameText;
        private var _fightScoreTxt:FilterFrameText;
        private var _winScoreTxt:FilterFrameText;
        private var _winSeriesTxt:FilterFrameText;
        private var _currentCountTxt:FilterFrameText;
        private var _testTxt:FilterFrameText;
        private var _model:ArenaModel;
        private var _state:Boolean = true;

        public function ArenaInformationView()
        {
            this._model = ArenaManager.instance.model;
            this.setPos();
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            mouseChildren = true;
            mouseEnabled = true;
            this._bg = ComponentFactory.Instance.creatBitmap("bitmap.ddtarena.informationviewBg");
            addChild(this._bg);
            this._lifeFlag = new LifeFlagIcon();
            PositionUtils.setPos(this._lifeFlag, "ddtarena.informationview.LifeFlagIconpos");
            addChild(this._lifeFlag);
            this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("ddtarena.informationview.helpBtn");
            addChild(this._helpBtn);
            this._expandBtn = ComponentFactory.Instance.creatComponentByStylename("ddtarena.informationview.clickBtn");
            this._expandBtn.setFrame(1);
            addChild(this._expandBtn);
            this.initTxt();
        }

        public function update():void
        {
            this.updateTxt();
        }

        private function initTxt():void
        {
            this._lifeTxt = ComponentFactory.Instance.creatComponentByStylename("ddtarena.informationview.lifeTxt");
            addChild(this._lifeTxt);
            this._fightScoreTxt = ComponentFactory.Instance.creatComponentByStylename("ddtarena.informationview.fightScoreTxt");
            addChild(this._fightScoreTxt);
            this._winScoreTxt = ComponentFactory.Instance.creatComponentByStylename("ddtarena.informationview.winScoreTxt");
            addChild(this._winScoreTxt);
            this._winSeriesTxt = ComponentFactory.Instance.creatComponentByStylename("ddtarena.informationview.winSeriesTxt");
            addChild(this._winSeriesTxt);
            this._currentCountTxt = ComponentFactory.Instance.creatComponentByStylename("ddtarena.informationview.currentCountTxt");
            addChild(this._currentCountTxt);
            this._testTxt = ComponentFactory.Instance.creatComponentByStylename("ddtarena.informationview.lifeTxt");
            this._testTxt.x = 49;
            this._testTxt.y = 6;
            this.updateTxt();
        }

        private function updateTxt():void
        {
            if ((!(this._model.selfInfo)))
            {
                this._lifeTxt.text = ("X " + "0");
                this._fightScoreTxt.text = "0";
                this._winScoreTxt.text = "0";
                this._winSeriesTxt.text = "0";
                this._currentCountTxt.text = "0";
                this._testTxt.text = (((("ID: " + "0") + "--") + "Level:") + "0");
            }
            else
            {
                this._lifeTxt.text = ("X " + ArenaManager.instance.model.selfInfo.arenaFlag);
                this._fightScoreTxt.text = ArenaManager.instance.model.selfInfo.arenaFightScore.toString();
                this._winScoreTxt.text = ArenaManager.instance.model.selfInfo.arenaWinScore.toString();
                this._winSeriesTxt.text = ArenaManager.instance.model.selfInfo.arenaMaxWin.toString();
                this._currentCountTxt.text = ArenaManager.instance.model.selfInfo.arenaCount.toString();
                this._testTxt.text = (((("ID: " + ArenaManager.instance.model.selfInfo.sceneID) + "--") + "Level:") + ArenaManager.instance.model.selfInfo.sceneLevel);
            };
        }

        private function initEvent():void
        {
            this._helpBtn.addEventListener(MouseEvent.CLICK, this.__openHelpFrame);
            this._expandBtn.addEventListener(MouseEvent.CLICK, this.__expand);
        }

        private function __openHelpFrame(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:ArenaHelpFrame = ComponentFactory.Instance.creatComponentByStylename("ddtarena.ArenaHelpFrame");
            _local_2.show();
        }

        private function __expand(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._state)
            {
                TweenLite.to(this, 0.4, {
                    "x":((this.x + this.width) - this._expandBtn.width),
                    "onComplete":this.expandComplete
                });
                this._expandBtn.setFrame(2);
            }
            else
            {
                TweenLite.to(this, 0.4, {
                    "x":((this.x - this.width) + this._expandBtn.width),
                    "onComplete":this.expandComplete
                });
                this._expandBtn.setFrame(1);
            };
        }

        private function expandComplete():void
        {
            this._state = (!(this._state));
        }

        private function setPos():void
        {
            PositionUtils.setPos(this, "ddtarena.informationview.pos");
        }

        private function removeView():void
        {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._helpBtn);
            this._helpBtn = null;
            ObjectUtils.disposeObject(this._lifeFlag);
            this._lifeFlag = null;
            ObjectUtils.disposeObject(this._lifeTxt);
            this._lifeTxt = null;
            ObjectUtils.disposeObject(this._testTxt);
            this._testTxt = null;
            ObjectUtils.disposeObject(this._fightScoreTxt);
            this._fightScoreTxt = null;
            ObjectUtils.disposeObject(this._winScoreTxt);
            this._winScoreTxt = null;
            ObjectUtils.disposeObject(this._winSeriesTxt);
            this._winSeriesTxt = null;
            ObjectUtils.disposeObject(this._expandBtn);
            this._expandBtn = null;
            ObjectUtils.disposeObject(this._currentCountTxt);
            this._currentCountTxt = null;
        }

        private function removeEvent():void
        {
            this._helpBtn.removeEventListener(MouseEvent.CLICK, this.__openHelpFrame);
            this._expandBtn.removeEventListener(MouseEvent.CLICK, this.__expand);
        }

        public function dispose():void
        {
            this.removeEvent();
            this.removeView();
        }


    }
}//package arena.view

