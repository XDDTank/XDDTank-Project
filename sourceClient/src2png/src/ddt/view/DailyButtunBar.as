// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.DailyButtunBar

package ddt.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.effect.IEffect;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.effect.EffectManager;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.manager.PathManager;
    import flash.events.MouseEvent;
    import com.pickgliss.effect.EffectTypes;
    import platformapi.tencent.DiamondManager;
    import ddt.manager.SoundManager;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import com.pickgliss.ui.LayerManager;
    import feedback.FeedbackManager;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import flash.external.ExternalInterface;

    public class DailyButtunBar extends Sprite implements Disposeable 
    {

        private static var instance:DailyButtunBar;

        private var _bg:ScaleFrameImage;
        private var _inited:Boolean;
        private var _downLoadClientBtn:BaseButton;
        private var _complainBtn:BaseButton;
        private var _dailyBtn:SimpleBitmapButton;
        private var _complainShineEffect:IEffect;

        public function DailyButtunBar():void
        {
            this._inited = false;
        }

        public static function get Insance():DailyButtunBar
        {
            if (instance == null)
            {
                instance = new (DailyButtunBar)();
            };
            return (instance);
        }


        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._dailyBtn);
            this._dailyBtn = null;
            ObjectUtils.disposeObject(this._downLoadClientBtn);
            this._downLoadClientBtn = null;
            ObjectUtils.disposeObject(this._complainBtn);
            this._complainBtn = null;
            if (this._complainShineEffect)
            {
                EffectManager.Instance.removeEffect(this._complainShineEffect);
                this._complainShineEffect = null;
            };
            this._inited = false;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function hide():void
        {
            this.dispose();
        }

        public function initView():void
        {
            var _local_1:Rectangle;
            if (this._inited)
            {
                return;
            };
            this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.toolbar.complainBtnAndDownloadBtnBg");
            addChild(this._bg);
            this._bg.visible = false;
            this._dailyBtn = ComponentFactory.Instance.creatComponentByStylename("toolbar.ShortCutBtn");
            this._dailyBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.shortcut");
            this._downLoadClientBtn = ComponentFactory.Instance.creatComponentByStylename("core.hall.clientDownloadBtn");
            this._downLoadClientBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.downLoadClient");
            if (PathManager.solveClientDownloadPath() != "")
            {
                this._bg.visible = true;
                addChild(this._downLoadClientBtn);
            };
            this._downLoadClientBtn.addEventListener(MouseEvent.CLICK, this.__onActionClick);
            if (PathManager.solveFeedbackEnable())
            {
                this._bg.visible = true;
                this._complainBtn = ComponentFactory.Instance.creatComponentByStylename("toolbar.complainbtn");
                addChild(this._complainBtn);
                if (PathManager.solveClientDownloadPath() == "")
                {
                    this._bg.setFrame(2);
                    this._complainBtn.y = (this._complainBtn.y - 34);
                }
                else
                {
                    this._bg.setFrame(1);
                };
                _local_1 = ComponentFactory.Instance.creatCustomObject("feedback.btnGlowRec");
                this._complainShineEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT, this._complainBtn, "asset.feedback.btnGlow", _local_1);
            }
            else
            {
                this._bg.setFrame(2);
            };
            if (DiamondManager.instance.isInTencent)
            {
                this._downLoadClientBtn.visible = false;
            };
            this.initEvent();
            this._inited = true;
        }

        private function __onActionClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            navigateToURL(new URLRequest(PathManager.solveClientDownloadPath()));
        }

        public function show():void
        {
            this.initView();
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_UI_LAYER, false, 0, false);
            if (FeedbackManager.instance.feedbackReplyData)
            {
                if (FeedbackManager.instance.feedbackReplyData.length <= 0)
                {
                    this.setComplainGlow(false);
                }
                else
                {
                    this.setComplainGlow(true);
                };
            };
        }

        public function setComplainGlow(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                if (this._complainShineEffect)
                {
                    this._complainShineEffect.play();
                };
            }
            else
            {
                if (this._complainShineEffect)
                {
                    this._complainShineEffect.stop();
                };
            };
        }

        private function __onComplainClick(event:MouseEvent):void
        {
            SoundManager.instance.play("015");
            try
            {
                FeedbackManager.instance.show();
            }
            catch(e:Error)
            {
                UIModuleSmallLoading.Instance.progress = 0;
                UIModuleSmallLoading.Instance.show();
                UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, __onClose);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, __progressShow);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, __complainShow);
                UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_FEEDBACK);
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
        }

        private function __progressShow(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDT_FEEDBACK)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function __complainShow(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDT_FEEDBACK)
            {
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
                UIModuleSmallLoading.Instance.hide();
                FeedbackManager.instance.show();
            };
        }

        private function __onShortCutClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("015");
            var _local_2:String = PathManager.solveLogin();
            var _local_3:String = escape(_local_2);
            if (ExternalInterface.available)
            {
                ExternalInterface.call("setFlashCall");
            };
            navigateToURL(new URLRequest(("CreatShortCut.ashx?gameurl=" + _local_3)), "_blank");
        }

        private function initEvent():void
        {
            this._dailyBtn.addEventListener(MouseEvent.CLICK, this.__onShortCutClick);
            if (PathManager.solveFeedbackEnable())
            {
                this._complainBtn.addEventListener(MouseEvent.CLICK, this.__onComplainClick);
            };
        }

        private function removeEvent():void
        {
            if (this._dailyBtn != null)
            {
                this._dailyBtn.removeEventListener(MouseEvent.CLICK, this.__onShortCutClick);
            };
            if (PathManager.solveFeedbackEnable())
            {
                if (this._complainBtn != null)
                {
                    this._complainBtn.removeEventListener(MouseEvent.CLICK, this.__onComplainClick);
                };
            };
            if (this._downLoadClientBtn)
            {
                this._downLoadClientBtn.removeEventListener(MouseEvent.CLICK, this.__onActionClick);
            };
        }


    }
}//package ddt.view

