// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossRankingFram

package worldboss.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.loader.UIModuleLoader;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.events.FrameEvent;
    import worldboss.player.RankingPersonInfo;
    import flash.geom.Point;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;

    public class WorldBossRankingFram extends BaseAlerFrame 
    {

        public static var _rankingPersons:Array = new Array();

        private var titleLineBg:MutipleImage;
        private var titleBg:MutipleImage;
        private var numTitle:FilterFrameText;
        private var nameTitle:FilterFrameText;
        private var souceTitle:FilterFrameText;
        private var _sureBtn:TextButton;

        public function WorldBossRankingFram()
        {
            super();
            try
            {
                this._init();
            }
            catch(error:Error)
            {
                UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_COREI);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, __onCoreiLoaded);
            };
        }

        private function __onCoreiLoaded(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDT_COREI)
            {
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onCoreiLoaded);
                this._init();
            };
        }

        public function _init():void
        {
            titleText = LanguageMgr.GetTranslation("worldboss.ranking.title");
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
            this.souceTitle.text = LanguageMgr.GetTranslation("worldboss.ranking.socre");
            addToContent(this.souceTitle);
            this._sureBtn = ComponentFactory.Instance.creat("worldboss.ranking.btn");
            this._sureBtn.text = LanguageMgr.GetTranslation("worldboss.ranking.OkBtnText");
            addToContent(this._sureBtn);
            this._sureBtn.addEventListener(MouseEvent.CLICK, this.__sureBtnClick);
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
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
            var _local_3:RankingPersonInfoItem;
            var _local_1:Point = ComponentFactory.Instance.creat("worldBoss.ranking.itemPos");
            var _local_2:int;
            while (_local_2 < _rankingPersons.length)
            {
                _local_3 = new RankingPersonInfoItem((_local_2 + 1), (_rankingPersons[_local_2] as RankingPersonInfo));
                _local_3.x = _local_1.x;
                _local_3.y = ((_local_1.y * (_local_2 + 1)) + 48);
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
}//package worldboss.view

