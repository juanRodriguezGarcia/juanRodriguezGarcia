Se debe tener permisos de ecs: execute-command   y describe task 
Se debe tener instalado cli-v2
Se debe tener permisos de session manager sobre el rol de las tareas 
Se debe tener instalado en la maquina el pugin de de session manager para el inicio de session

Comandos fargate 


Instalar session manager plugin:
https://s3.amazonaws.com/session-manager-downloads/plugin/latest/windows/SessionManagerPluginSetup.exe
https://docs.aws.amazon.com/systems-manager/latest/userguide/install-plugin-linux.html


Validar que este activo la ejecucion de comandos:
aws ecs describe-tasks --cluster ClusterFargateDemo --tasks 9fdd0220f6484313bd9505020dc9a109| grep enableExecuteCommand

esto forza a una nueva tarea
aws ecs update-service --cluster ClusterFargateDemo --service servicio-nginx-fargate-v5 --region us-east-2 --enable-execute-command --force-new-deployment


aws ecs describe-tasks --cluster ClusterFargateDemo --tasks 9fdd0220f6484313bd9505020dc9a109| grep enableExecuteCommand

Acceder a contenedor:
aws ecs execute-command --region us-east-2 --cluster ClusterFargateDemo --container contenedor-fargate --task 9fdd0220f6484313bd9505020dc9a109 --command "/bin/bash" --interactive
Si se genera el siguiente error es porque falta dar permisos de session manager al task del docker:
aws ecs execute-command --region us-east-2 --cluster ClusterFargateDemo --container contenedor-fargate --task 9fdd0220f6484313bd9505020dc9a109 --command "/bin/bash" --interactive


The Session Manager plugin was installed successfully. Use the AWS CLI to start a session.
An error occurred (TargetNotConnectedException) when calling the ExecuteCommand operation: The execute command failed due to an internal error. Try again later.

{
   "Version": "2012-10-17",
   "Statement": [
       {
       "Effect": "Allow",
       "Action": [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
       ],
      "Resource": "*"
      }
   ]
}





Tener session manager instalado y aws-cli CON version  2 (Instalar una amazon-linux)
https://docs.aws.amazon.com/systems-manager/latest/userguide/install-plugin-linux.html
