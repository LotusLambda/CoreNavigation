extension Navigator {
    func passData(
        _ block: ((DataPassing.Context<Any>) -> Void)?,
        to potentialDataReceivables: [Any?]) {
        guard let block = block else { return }
        let potentialDataReceivables = potentialDataReceivables.compactMap { $0 as? AnyDataReceivable }
        potentialDataReceivables.forEach { (dataReceivable) in
            queue.sync {
                block(DataPassing.Context<Any>(onPassData: { data in
                    self.queue.sync {
                        dataReceivable.didReceiveAnyData(data)
                    }
                }))
            }
        }
    }
}
