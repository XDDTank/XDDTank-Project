// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.bossbox.BossBoxView

package ddt.view.bossbox
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.image.MovieImage;
    import flash.utils.Timer;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SoundManager;
    import flash.utils.setTimeout;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.BossBoxManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SocketManager;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;
    import flash.utils.clearTimeout;

    public class BossBoxView extends Sprite implements Disposeable 
    {

        private var _bg:ScaleBitmapImage;
        private var _downBox:MovieImage;
        private var _templateIds:Array;
        public var boxType:int = 0;
        public var boxID:int;
        private var _time:Timer;
        private var awards:AwardsView;
        private var _fightLibType:int;
        private var _fightLibLevel:int;
        private var _mission:int;
        private var _alertTitle:FilterFrameText;
        private var _frame:BaseAlerFrame;
        private var _winTime:uint;

        public function BossBoxView(_arg_1:int, _arg_2:int, _arg_3:Array, _arg_4:int=-1, _arg_5:int=-1)
        {
            buttonMode = true;
            this._templateIds = _arg_3;
            this.boxType = _arg_1;
            this.boxID = _arg_2;
            this._fightLibType = _arg_4;
            this._fightLibLevel = _arg_5;
            this.init();
            this.initEvent();
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creat("bossbox.TimeBoxBG");
            this._downBox = ComponentFactory.Instance.creat("bossbox.downBox");
            addChild(this._bg);
            addChild(this._downBox);
            SoundManager.instance.pauseMusic();
            SoundManager.instance.play("1001");
            this._winTime = setTimeout(this.startMusic, 3000);
        }

        private function startMusic():void
        {
            SoundManager.instance.resumeMusic();
            SoundManager.instance.stop("1001");
        }

        private function initEvent():void
        {
            addEventListener(MouseEvent.CLICK, this._boxClick);
        }

        private function removeEvent():void
        {
            removeEventListener(MouseEvent.CLICK, this._boxClick);
        }

        private function _boxClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._downBox.movie.gotoAndPlay("openBox");
            this.removeEvent();
            this._time = new Timer(500, 1);
            this._time.start();
            this._time.addEventListener(TimerEvent.TIMER_COMPLETE, this._time_complete);
        }

        private function _time_complete(_arg_1:TimerEvent):void
        {
            var _local_2:AlertInfo;
            if (this.boxType == BossBoxManager.FightLibAwardBox)
            {
                this._frame = ComponentFactory.Instance.creatComponentByStylename("bossbox.AwardsFrame");
                this.awards = new AwardsView();
                this.awards.boxType = this.boxType;
                this.awards.goodsList = this._templateIds;
                this._frame.addToContent(this.awards);
                this._alertTitle = ComponentFactory.Instance.creatComponentByStylename("bossbox.alert.alertTextStyle");
                this._alertTitle.text = LanguageMgr.GetTranslation("tank.timeBox.awardsTitle");
                this._frame.addToContent(this._alertTitle);
                _local_2 = new AlertInfo();
                _local_2.title = LanguageMgr.GetTranslation("tank.timeBox.awardsInfo");
                _local_2.showCancel = false;
                _local_2.moveEnable = false;
                _local_2.submitLabel = LanguageMgr.GetTranslation("tank.timeBox.awardsBtn");
                this._frame.info = _local_2;
                this._frame.submitButtonStyle = "bossbox.getAwardBtn";
                this._frame.addEventListener(FrameEvent.RESPONSE, this._close);
                LayerManager.Instance.addToLayer(this._frame, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            }
            else
            {
                this.awards = ComponentFactory.Instance.creat("bossbox.AwardsViewAsset");
                this.awards.closeButton.visible = false;
                this.awards.escEnable = false;
                this.awards.boxType = this.boxType;
                this.awards.goodsList = this._templateIds;
                this.awards.addEventListener(AwardsView.HAVEBTNCLICK, this._close);
                LayerManager.Instance.addToLayer(this.awards, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            };
            removeChild(this._downBox);
            removeChild(this._bg);
            this._downBox = null;
            this._bg = null;
            this._time.removeEventListener(TimerEvent.TIMER_COMPLETE, this._time_complete);
            this._time.stop();
            this._time = null;
        }

        private function _close(_arg_1:Event):void
        {
            switch (this.boxType)
            {
                case 0:
                    SocketManager.Instance.out.sendGetTimeBox(1, this.boxType);
                    break;
                case 1:
                    SocketManager.Instance.out.sendGetTimeBox(1, this.boxType);
                    BossBoxManager.instance.showOtherGradeBox();
                    break;
                case BossBoxManager.FightLibAwardBox:
                    this._frame.removeEventListener(AwardsView.HAVEBTNCLICK, this._close);
                    this._frame.dispose();
                    SocketManager.Instance.out.sendGetTimeBox(2, -1, this._fightLibType, this._fightLibLevel);
                    break;
                case BossBoxManager.SignAward:
                    break;
            };
            this.dispose();
        }

        public function dispose():void
        {
            SoundManager.instance.resumeMusic();
            this.removeEvent();
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._downBox)
            {
                ObjectUtils.disposeObject(this._downBox);
            };
            this._downBox = null;
            clearTimeout(this._winTime);
            if (this._time)
            {
                this._time.removeEventListener(TimerEvent.TIMER_COMPLETE, this._time_complete);
                this._time.stop();
            };
            this._time = null;
            if (this._alertTitle)
            {
                ObjectUtils.disposeObject(this._alertTitle);
            };
            this._alertTitle = null;
            if (this._frame)
            {
                this._frame.removeEventListener(AwardsView.HAVEBTNCLICK, this._close);
                ObjectUtils.disposeObject(this._frame);
            };
            this._frame = null;
            if (this.awards)
            {
                this.awards.removeEventListener(AwardsView.HAVEBTNCLICK, this._close);
                ObjectUtils.disposeObject(this.awards);
            };
            this.awards = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.bossbox

