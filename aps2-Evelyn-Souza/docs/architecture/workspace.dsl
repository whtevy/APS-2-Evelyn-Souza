workspace "Marketplace B2B de Sobras Industriais" "Fronteiras do sistema e interação com empresa compradora e empresa vendedora." {

    model {
        comprador = person "Empresa compradora" "Ator externo que pesquisa anúncios, envia propostas e acompanha as respostas."
        vendedor = person "Empresa vendedora" "Ator externo que publica anúncios, analisa propostas e aceita ou recusa negociações."

        marketplace = softwareSystem "Marketplace B2B de Sobras Industriais" "Plataforma que intermedeia propostas e negociações entre empresas." {
            web = container "Frontend Web" "Interface utilizada pelas empresas compradora e vendedora." "React, TypeScript" {
                tags "Web"
            }
            api = container "API Marketplace" "Recebe requisições, valida acesso e encaminha casos de uso." "Node.js, Express, REST/JSON"
            proposta = container "Serviço de Propostas" "Valida, registra e controla o ciclo de vida das propostas." "Node.js, TypeScript"
            transacao = container "Serviço de Transações" "Cria a negociação após o aceite da proposta." "Node.js, TypeScript"
            banco = container "Banco de Dados" "Armazena empresas, anúncios, propostas, transações e auditoria." "PostgreSQL"
            broker = container "Broker de Eventos" "Distribui eventos para processamento assíncrono." "RabbitMQ, AMQP 0-9-1"
            notificacao = container "Serviço de Notificações" "Notifica as empresas sobre propostas e respostas." "Node.js"
        }

        comprador -> web "Acessa, envia proposta e acompanha status" "HTTPS"
        vendedor -> web "Publica anúncio e responde propostas" "HTTPS"
        web -> api "Envia requisições e recebe DTOs" "HTTPS / REST / JSON"
        api -> proposta "Executa operações de proposta" "HTTP interno / JSON"
        proposta -> banco "Consulta e persiste propostas" "SQL / TCP"
        proposta -> transacao "Solicita criação de transação após aceite" "HTTP interno / JSON"
        transacao -> banco "Persiste transação" "SQL / TCP"
        proposta -> broker "Publica eventos de proposta" "AMQP 0-9-1"
        transacao -> broker "Publica evento de transação criada" "AMQP 0-9-1"
        broker -> notificacao "Entrega eventos" "AMQP 0-9-1"
        notificacao -> web "Atualiza interface das empresas" "WebSocket / HTTPS"
    }

    views {
        container marketplace "Containers" {
            include *
            autolayout lr
        }
        styles {
            element "Person" {
                shape person
                background "#08427b"
                color "#ffffff"
            }
            element "Software System" {
                background "#1168bd"
                color "#ffffff"
            }
            element "Container" {
                background "#438dd5"
                color "#ffffff"
            }
        }
    }
}
