// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.StateManager

package ddt.manager
{
    import flash.utils.Dictionary;
    import flash.display.Sprite;
    import ddt.states.BaseStateView;
    import flash.display.Stage;
    import ddt.states.FadingBlock;
    import ddt.states.IStateCreator;
    import ddt.states.StateType;
    import com.pickgliss.ui.ShowTipManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.utils.MenoryUtil;
    import ddt.view.chat.ChatBugleView;
    import email.manager.MailManager;
    import com.pickgliss.loader.LoaderSavingManager;

    public class StateManager 
    {

        private static var dic:Dictionary;
        private static var root:Sprite;
        private static var _current:BaseStateView;
        private static var next:BaseStateView;
        private static var _currentStateType:String;
        public static var getInGame_Step_1:Boolean = false;
        public static var getInGame_Step_2:Boolean = false;
        public static var getInGame_Step_3:Boolean = false;
        public static var getInGame_Step_4:Boolean = false;
        public static var getInGame_Step_5:Boolean = false;
        public static var getInGame_Step_6:Boolean = false;
        public static var getInGame_Step_7:Boolean = false;
        public static var getInGame_Step_8:Boolean = false;
        private static var _stage:Stage;
        public static var isShowFadingAnimation:Boolean = true;
        private static var fadingBlock:FadingBlock;
        private static var _creator:IStateCreator;
        private static var _data:Object;


        public static function get currentStateType():String
        {
            return (_currentStateType);
        }

        public static function set currentStateType(_arg_1:String):void
        {
            _currentStateType = _arg_1;
        }

        public static function get isInFight():Boolean
        {
            return ((_currentStateType == StateType.FIGHTING) || (_currentStateType == StateType.MULTISHOOT_FIGHTING));
        }

        public static function get nextState():BaseStateView
        {
            return (next);
        }

        public static function setup(_arg_1:Sprite, _arg_2:IStateCreator):void
        {
            dic = new Dictionary();
            root = _arg_1;
            _creator = _arg_2;
            fadingBlock = new FadingBlock(addNextToStage, showLoading);
        }

        public static function setState(_arg_1:String="default", _arg_2:Object=null):void
        {
            var _local_3:BaseStateView = getState(_arg_1);
            if (((_arg_1 == StateType.ROOM_LIST) && (current.getType() == StateType.MATCH_ROOM)))
            {
                if (((getInGame_Step_1) && (getInGame_Step_2)))
                {
                    if (((getInGame_Step_3) && (!(getInGame_Step_4))))
                    {
                        SocketManager.Instance.out.sendErrorMsg("游戏步骤进行到3之后停止了");
                    }
                    else
                    {
                        if (((getInGame_Step_4) && (!(getInGame_Step_5))))
                        {
                            SocketManager.Instance.out.sendErrorMsg("游戏步骤进行到4之后停止了");
                        }
                        else
                        {
                            if (((getInGame_Step_5) && (!(getInGame_Step_6))))
                            {
                                SocketManager.Instance.out.sendErrorMsg("游戏步骤进行到5之后停止了");
                            }
                            else
                            {
                                if (((getInGame_Step_6) && (!(getInGame_Step_7))))
                                {
                                    SocketManager.Instance.out.sendErrorMsg("游戏步骤进行到6之后停止了");
                                }
                                else
                                {
                                    if (((getInGame_Step_7) && (!(getInGame_Step_8))))
                                    {
                                        SocketManager.Instance.out.sendErrorMsg("游戏步骤进行到7之后停止了");
                                    };
                                };
                            };
                        };
                    };
                    getInGame_Step_1 = (getInGame_Step_2 = (getInGame_Step_3 = (getInGame_Step_4 = (getInGame_Step_5 = (getInGame_Step_6 = (getInGame_Step_7 = (getInGame_Step_8 = false)))))));
                };
            };
            _data = _arg_2;
            if (_local_3)
            {
                setStateImp(_local_3);
            }
            else
            {
                createStateAsync(_arg_1, createCallbak);
            };
        }

        public static function stopImidily():void
        {
            fadingBlock.stopImidily();
        }

        private static function createCallbak(_arg_1:BaseStateView):void
        {
            if (_arg_1)
            {
                dic[_arg_1.getType()] = _arg_1;
            };
            setStateImp(_arg_1);
        }

        private static function setStateImp(_arg_1:BaseStateView):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };
            if (((_arg_1 == current) || (next == _arg_1)))
            {
                current.refresh();
                return (false);
            };
            if (_arg_1.check(currentStateType))
            {
                QueueManager.pause();
                next = _arg_1;
                if ((!(next.prepared)))
                {
                    next.prepare();
                };
                ShowTipManager.Instance.removeAllTip();
                LayerManager.Instance.clearnGameDynamic();
                if (current)
                {
                    fadingBlock.setNextState(next);
                    fadingBlock.update();
                }
                else
                {
                    addNextToStage();
                };
                return (true);
            };
            return (false);
        }

        private static function addNextToStage():void
        {
            QueueManager.resume();
            if (current)
            {
                current.leaving(next);
            };
            var _local_1:BaseStateView = current;
            _current = next;
            currentStateType = current.getType();
            next = null;
            current.enter(_local_1, _data);
            MenoryUtil.clearMenory();
            root.addChild(current.getView());
            current.addedToStage();
            if (_local_1)
            {
                if (_local_1.getView().parent)
                {
                    _local_1.getView().parent.removeChild(_local_1.getView());
                };
                _local_1.removedFromStage();
            };
            if (current.goBack())
            {
                fadingBlock.executed = false;
                back();
            };
            EnthrallManager.getInstance().updateEnthrallView();
            ChatBugleView.instance.updatePos();
            MailManager.Instance.isOpenFromBag = false;
        }

        private static function showLoading():void
        {
            if (LoaderSavingManager.hasFileToSave)
            {
            };
        }

        public static function back():void
        {
            var _local_1:String;
            if (current != null)
            {
                _local_1 = current.getBackType();
                if (_local_1 != "")
                {
                    setState(_local_1);
                };
            };
        }

        public static function getState(_arg_1:String):BaseStateView
        {
            return (dic[_arg_1] as BaseStateView);
        }

        public static function createStateAsync(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            _creator.createAsync(_arg_1, _arg_2, _arg_3);
        }

        public static function isExitGame(_arg_1:String):Boolean
        {
            return (((!(_arg_1 == StateType.FIGHTING)) && (!(_arg_1 == StateType.MISSION_ROOM))) && (!(_arg_1 == StateType.FIGHT_LIB_GAMEVIEW)));
        }

        public static function isExitRoom(_arg_1:String):Boolean
        {
            return ((((((((((!(_arg_1 == StateType.FIGHTING)) && (!(_arg_1 == StateType.MULTISHOOT_FIGHTING))) && (!(_arg_1 == StateType.MATCH_ROOM))) && (!(_arg_1 == StateType.MISSION_ROOM))) && (!(_arg_1 == StateType.DUNGEON_ROOM))) && (!(_arg_1 == StateType.CHALLENGE_ROOM))) && (!(_arg_1 == StateType.ROOM_LOADING))) && (!(_arg_1 == StateType.FIGHT_LIB))) && (!(_arg_1 == StateType.TRAINER1))) && (!(_arg_1 == StateType.TRAINER2)));
        }

        public static function isInGame(_arg_1:String):Boolean
        {
            switch (_arg_1)
            {
                case StateType.FIGHTING:
                case StateType.TRAINER1:
                case StateType.TRAINER2:
                case StateType.FIGHT_LIB_GAMEVIEW:
                case StateType.MULTISHOOT_FIGHTING:
                    return (true);
                default:
                    return (false);
            };
        }

        public static function get current():BaseStateView
        {
            return (_current);
        }


    }
}//package ddt.manager

