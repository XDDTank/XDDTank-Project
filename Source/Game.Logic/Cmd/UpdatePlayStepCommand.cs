using Game.Logic.Phy.Object;
using Game.Base.Packets;
using log4net;
using System.Reflection;

namespace Game.Logic.Cmd
{
    [GameCommand((int)eTankCmdType.MISSION_CMD,"希望成为队长")]
    public class UpdatePlayStep: ICommandHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void HandleCommand(BaseGame game,Player player, GSPacketIn packet)
        {
            int key = packet.ReadInt();
            string step = packet.ReadString();
            //log.Error(string.Format("==>Player Id: {0} step: {1}", player.Id, step));
        }
    }
}
