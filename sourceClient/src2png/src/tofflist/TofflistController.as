// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tofflist.TofflistController

package tofflist
{
    import ddt.states.BaseStateView;
    import tofflist.view.TofflistMainFrame;
    import consortion.ConsortionModelControl;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.states.StateType;

    public class TofflistController extends BaseStateView 
    {

        private static var _instance:TofflistController;

        private var _view:TofflistMainFrame;
        private var _temporaryTofflistListData:String;


        public static function get Instance():TofflistController
        {
            if (_instance == null)
            {
                _instance = new (TofflistController)();
            };
            return (_instance);
        }


        public function setup():void
        {
            this.openToffilist();
        }

        private function openToffilist():void
        {
            this.init();
            this._view.addEvent();
            ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.selfConsortionComplete, 1, 6, PlayerManager.Instance.Self.ConsortiaName, -1, -1, -1, PlayerManager.Instance.Self.ConsortiaID);
            if (TofflistModel.Instance.rankInfo == null)
            {
                TofflistModel.Instance.loadRankInfo();
            };
        }

        private function init():void
        {
            this._view = ComponentFactory.Instance.creatCustomObject("ddtTofflistMainFrame", [this]);
            this._view.show();
            this.loadFormData("personalBattleAccumulate");
        }

        override public function getView():DisplayObject
        {
            return (this._view);
        }

        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            super.enter(_arg_1, _arg_2);
            this.init();
            ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.selfConsortionComplete, 1, 6, PlayerManager.Instance.Self.ConsortiaName, -1, -1, -1, PlayerManager.Instance.Self.ConsortiaID);
            if (TofflistModel.Instance.rankInfo == null)
            {
                TofflistModel.Instance.loadRankInfo();
            };
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._view);
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            this.dispose();
            super.leaving(_arg_1);
        }

        override public function getBackType():String
        {
            return (StateType.MAIN);
        }

        override public function getType():String
        {
            return (StateType.TOFFLIST);
        }

        public function loadFormData(_arg_1:String):void
        {
            TofflistModel.Instance[_arg_1] = TofflistModel.Instance[_arg_1];
        }

        public function clearDisplayContent():void
        {
            this._view.clearDisplayContent();
        }

        public function loadList(_arg_1:int):void
        {
        }


    }
}//package tofflist

