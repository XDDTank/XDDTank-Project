// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.model.MapSceneModel

package SingleDungeon.model
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import ddt.data.quest.QuestInfo;
    import SingleDungeon.event.CDCollingEvent;
    import __AS3__.vec.*;

    public class MapSceneModel extends EventDispatcher 
    {

        public static const WALKSCENE:int = 2;

        public var ID:int;
        public var Name:String;
        public var Type:int;
        public var MapID:int;
        public var Path:String;
        public var MapX:Number;
        public var MapY:Number;
        public var MinLevel:int;
        public var MaxLevel:int;
        public var QuestID:int;
        public var QuestType:int;
        public var Other:String;
        public var OtherCount:int;
        public var MissionID:int;
        public var Description:String;
        public var SenceSelfInfo:SingleDungeonPlayerInfo;
        public var ClothPath:String;
        public var CoolMoney:String;
        public var RelevanceQuest:String;
        public var CostEnergy:int;
        public var questData:Vector.<QuestInfo> = new Vector.<QuestInfo>();
        private var _cdColling:int;
        private var _count:int;


        public function get cdColling():int
        {
            return (this._cdColling);
        }

        public function set cdColling(_arg_1:int):void
        {
            this._cdColling = _arg_1;
            dispatchEvent(new CDCollingEvent(CDCollingEvent.CD_UPDATE));
        }

        public function get count():int
        {
            return (this._count);
        }

        public function set count(_arg_1:int):void
        {
            this._count = _arg_1;
        }


    }
}//package SingleDungeon.model

