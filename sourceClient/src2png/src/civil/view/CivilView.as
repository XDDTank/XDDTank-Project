// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//civil.view.CivilView

package civil.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.MovieClip;
    import civil.CivilController;
    import civil.CivilModel;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import flash.display.Bitmap;
    import com.pickgliss.utils.ClassUtils;
    import ddt.utils.PositionUtils;
    import ddt.manager.ChatManager;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class CivilView extends Sprite implements Disposeable 
    {

        private var _civilBg:MovieClip;
        private var _civilLeftView:CivilLeftView;
        private var _civilRightView:CivilRightView;
        private var _controller:CivilController;
        private var _model:CivilModel;
        private var _chatFrame:Sprite;
        private var _titleBg:ScaleFrameImage;
        private var _titleText:Bitmap;

        public function CivilView(_arg_1:CivilController, _arg_2:CivilModel)
        {
            this._controller = _arg_1;
            this._model = _arg_2;
            this.init();
        }

        private function init():void
        {
            this._civilBg = (ClassUtils.CreatInstance("asset.ddtcivil.Bg") as MovieClip);
            PositionUtils.setPos(this._civilBg, "ddtcivil.bgPos");
            addChild(this._civilBg);
            this._civilLeftView = new CivilLeftView(this._controller, this._model);
            this._civilRightView = new CivilRightView(this._controller, this._model);
            ChatManager.Instance.state = ChatManager.CHAT_CIVIL_VIEW;
            this._chatFrame = ChatManager.Instance.view;
            addChild(this._civilLeftView);
            addChild(this._civilRightView);
            addChild(this._chatFrame);
            this._titleBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.titleBgImg");
            this._titleText = ComponentFactory.Instance.creatBitmap("asset.ddtcivil.titleText");
            addChild(this._titleBg);
            addChild(this._titleText);
        }

        public function dispose():void
        {
            if (this._civilBg)
            {
                ObjectUtils.disposeObject(this._civilBg);
                this._civilBg = null;
            };
            if (this._civilLeftView)
            {
                ObjectUtils.disposeObject(this._civilLeftView);
                this._civilLeftView = null;
            };
            if (this._civilRightView)
            {
                ObjectUtils.disposeObject(this._civilRightView);
                this._civilRightView = null;
            };
            if (this._titleBg)
            {
                ObjectUtils.disposeObject(this._titleBg);
                this._titleBg = null;
            };
            if (this._titleText)
            {
                ObjectUtils.disposeObject(this._titleText);
                this._titleText = null;
            };
            this._chatFrame = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package civil.view

