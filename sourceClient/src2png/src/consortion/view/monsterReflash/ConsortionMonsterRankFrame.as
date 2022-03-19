// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.monsterReflash.ConsortionMonsterRankFrame

package consortion.view.monsterReflash
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.events.FrameEvent;
    import worldboss.player.RankingPersonInfo;
    import worldboss.view.RankingPersonInfoItem;
    import flash.geom.Point;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ConsortionMonsterRankFrame extends BaseAlerFrame 
    {

        public static var _rankingPersons:Array = new Array();

        private var titleLineBg:MutipleImage;
        private var titleBg:MutipleImage;
        private var numTitle:FilterFrameText;
        private var nameTitle:FilterFrameText;
        private var souceTitle:FilterFrameText;
        private var _sureBtn:TextButton;

        public function ConsortionMonsterRankFrame()
        {
            this.initView();
        }

        private function initView():void
        {
            titleText = LanguageMgr.GetTranslation("consortion.totalInfo.frameTitle");
            this.titleBg = ComponentFactory.Instance.creatComponentByStylename("worldboss.RankingFrame.RankingTitleBg");
            addToContent(this.titleBg);
            this.titleLineBg = ComponentFactory.Instance.creatComponentByStylename("worldboss.RankingItem.bgLine");
            addToContent(this.titleLineBg);
            this.numTitle = ComponentFactory.Instance.creatComponentByStylename("worldboss.ranking.numTitle");
            this.numTitle.text = LanguageMgr.GetTranslation("worldboss.ranking.num");
            addToContent(this.numTitle);
            this.nameTitle = ComponentFactory.Instance.creatComponentByStylename("worldboss.ranking.nameTitle");
            this.nameTitle.text = LanguageMgr.GetTranslation("worldboss.ranking.name");
            addToContent(this.nameTitle);
            this.souceTitle = ComponentFactory.Instance.creatComponentByStylename("worldboss.ranking.souceTitle");
            this.souceTitle.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.contribution.text");
            addToContent(this.souceTitle);
            this._sureBtn = ComponentFactory.Instance.creat("worldboss.ranking.btn");
            this._sureBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
            addToContent(this._sureBtn);
            this._sureBtn.addEventListener(MouseEvent.CLICK, this.__sureBtnClick);
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
        }

        private function testRanking():void
        {
            var _local_2:RankingPersonInfo;
            var _local_1:int;
            while (_local_1 < 10)
            {
                _local_2 = new RankingPersonInfo();
                _local_2.id = _local_1;
                _local_2.damage = (20 * _local_1);
                _local_2.name = ("danny" + _local_1);
                _local_2.isVip = (((_local_1 % 2) == 0) ? true : false);
                this.addPersonRanking(_local_2);
                _local_1++;
            };
        }

        public function addPersonRanking(_arg_1:RankingPersonInfo):void
        {
            var _local_3:int;
            var _local_2:Boolean;
            if (_rankingPersons.length == 0)
            {
                _rankingPersons.push(_arg_1);
            }
            else
            {
                _local_3 = 0;
                while (_local_3 < _rankingPersons.length)
                {
                    if ((_rankingPersons[_local_3] as RankingPersonInfo).damage < _arg_1.damage)
                    {
                        _rankingPersons.splice(_local_3, 0, _arg_1);
                        return;
                    };
                    _local_3++;
                };
                _rankingPersons.push(_arg_1);
            };
        }

        public function show():void
        {
            var _local_2:int;
            var _local_3:RankingPersonInfoItem;
            var _local_1:Point = ComponentFactory.Instance.creat("worldBoss.ranking.itemPos");
            _local_2 = 0;
            while (_local_2 < _rankingPersons.length)
            {
                _local_3 = new RankingPersonInfoItem((_local_2 + 1), (_rankingPersons[_local_2] as RankingPersonInfo));
                _local_3.x = _local_1.x;
                _local_3.y = ((_local_1.y * (_local_2 + 1)) + 60);
                addChild(_local_3);
                _local_2++;
            };
            LayerManager.Instance.addToLayer(this, LayerManager.STAGE_DYANMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    SoundManager.instance.play("008");
                    this.dispose();
                    return;
            };
        }

        private function __sureBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
        }

        override public function dispose():void
        {
            super.dispose();
            var _local_1:int;
            while (_local_1 < _rankingPersons.length)
            {
                _rankingPersons.shift();
            };
            removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package consortion.view.monsterReflash

